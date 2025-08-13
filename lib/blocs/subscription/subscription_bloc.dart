import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:second_shot/blocs/app/app_bloc.dart';
import 'package:second_shot/models/subscription_model.dart';

import '../../data/repos/subscription_repo.dart';
import '../../utils/constants/result.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final repo = SubscriptionRepo();
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _streamSubscription;
  bool isCalled = false;
  final AppBloc appBloc;
  SubscriptionBloc(this.appBloc) : super(SubscriptionState.idle()) {
    on<InitializeSubscriptionEvent>((event, emit) => _initialize(event, emit));
    on<SelectAPlanEvent>((event, emit) => _selectAPlanEvent(event, emit));
    on<BuySubscriptionEvent>((event, emit) => _buy(event, emit));
    on<GetUserSubscriptionEvent>(
        (event, emit) => _getUserSubscriptionEvent(event, emit));
  }

  // Clear transaction queue in iOS sandbox for testing
  Future<void> _clearQueueInIOSSandbox() async {
    if (kDebugMode && Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (var transaction in transactions) {
        await SKPaymentQueueWrapper().finishTransaction(transaction);
        log('Finished transaction: ${transaction.transactionState.name}');
      }
    }
  }

  // Initialize subscription process and check product availability
  Future<void> _initialize(
      InitializeSubscriptionEvent event, Emitter emit) async {
    emit(state.copyWith(
        loading: true,
        selectedPlan: ProductDetails(
            id: '',
            title: 'title',
            description: '',
            price: 'price',
            rawPrice: 0,
            currencyCode: '')));

    final isAvailable = await _inAppPurchase.isAvailable();
    emit(state.copyWith(isAvailable: isAvailable));

    if (!isAvailable) {
      emit(state.copyWith(loading: false));
      return;
    }

    final Set<String> variants = {/*'quarterly_plan', */'yearly_plan', 'monthly_plan'};
    final response = await _inAppPurchase.queryProductDetails(variants);

    if (response.notFoundIDs.isNotEmpty) {
      log("The following product IDs were not found: ${response.notFoundIDs} Error: ${response.error?.toString()}");
    } else {
      log("The following product IDs were found: ${response.productDetails.map((e) => e.title)}");
    }

    emit(state.copyWith(loading: false, products: response.productDetails));

    // Listen for purchase updates
    await _listenToPurchaseUpdates(event, emit);
  }

  // Handle plan selection
  void _selectAPlanEvent(SelectAPlanEvent event, Emitter emit) {
    emit(state.copyWith(selectedPlan: event.plan));
  }

  // Handle subscription purchase
  Future<void> _buy(BuySubscriptionEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(loading: true));

      // Clear iOS sandbox queue
      await _clearQueueInIOSSandbox();

      if (state.selectedPlan == null) {
        emit(state.copyWith(
          loading: false,
          result: Result.error("No plan selected", event),
        ));
        return;
      }

      final PurchaseParam param =
          PurchaseParam(productDetails: state.selectedPlan!);
      log("Purchase Params: ${param.productDetails.id}");

      final res = await _inAppPurchase.buyNonConsumable(purchaseParam: param);
      log("Purchase Result: $res");
    } on PlatformException catch (e) {
      emit(state.copyWith(
        loading: false,
        result: Result.error(e.message.toString(), event),
      ));
      log(e.toString());
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        result: Result.error("Unknown error occurred", event),
      ));
      log(e.toString());
    }
  }

  Future<void> _listenToPurchaseUpdates(
      InitializeSubscriptionEvent event, Emitter emit) async {
    await emit.forEach<List<PurchaseDetails>>(
      _inAppPurchase.purchaseStream,
      onData: (purchaseDetailsList) {
        log("Purchase Details List: $purchaseDetailsList");
        final purchaseDetails = purchaseDetailsList.last;
        log("Purchase Status: ${purchaseDetails.status}");
        log("Product ID: ${purchaseDetails.productID}");

        if (purchaseDetails.status == PurchaseStatus.pending) {
          log("Purchase is pending");
          return state.copyWith(loading: true);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          if (isCalled == false) {
            _handlePurchaseSuccess(purchaseDetails, emit);
          }
          log('Purchase Completed');
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          log("Purchase Error: ${purchaseDetails.error}");
          return state.copyWith(
            loading: false,
            result:
                Result.error("Purchase error: ${purchaseDetails.error}", event),
          );
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          log("Purchase cancelled");
          return state.copyWith(
            loading: false,
            result: Result.error("Purchase cancelled", event),
          );
        }
        for (var purchaseDetailsItem in purchaseDetailsList) {
          if (purchaseDetailsItem.pendingCompletePurchase) {
            _inAppPurchase.completePurchase(purchaseDetailsItem);
          }
        }

        return state;
      },
      onError: (error, stackTrace) {
        log("Purchase Stream Error: $error");
        return state.copyWith(
          loading: false,
          result: Result.error("Failed to listen to purchases", event),
        );
      },
    );
  }

  //
  // // Listen to purchase updates and handle each purchase state
  // Future<void> _listenToPurchaseUpdates(
  //     InitializeSubscriptionEvent event, Emitter emit) async {
  //   // Ensure stream is initialized
  //   _streamSubscription = _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
  //     log("Purchase Details List: $purchaseDetailsList");
  //     final purchaseDetails = purchaseDetailsList.last;
  //     // for (var purchaseDetails in purchaseDetailsList) {
  //       log("Purchase Status: ${purchaseDetails.status}");
  //       log("Product ID: ${purchaseDetails.productID}");
  //
  //       if (purchaseDetails.status == PurchaseStatus.pending) {
  //         log("Purchase is pending");
  //         emit(state.copyWith(loading: true));
  //       } else if (purchaseDetails.status == PurchaseStatus.purchased) {
  //         _handlePurchaseSuccess(purchaseDetails, emit);
  //       } else if (purchaseDetails.status == PurchaseStatus.error) {
  //         log("Purchase Error: ${purchaseDetails.error}");
  //         emit(state.copyWith(
  //           loading: false,
  //           result: Result.error(
  //               "Purchase error: ${purchaseDetails.error?.message}", event),
  //         ));
  //       } else if (purchaseDetails.status == PurchaseStatus.canceled) {
  //         log("Purchase canceled");
  //         emit(state.copyWith(
  //           loading: false,
  //           result: Result.error("Purchase canceled", event),
  //         ));
  //       }
  //     for (var purchaseDetails in purchaseDetailsList) {
  //
  //       if (purchaseDetails.pendingCompletePurchase) {
  //         _inAppPurchase.completePurchase(purchaseDetails);
  //       }
  //     }
  //   }, onError: (error, stackTrace) {
  //     log("Purchase Stream Error: $error");
  //     emit(state.copyWith(
  //       loading: false,
  //       result: Result.error("Failed to listen to purchases", event),
  //     ));
  //   });
  // }

  // Handle successful purchase
  Future<void> _handlePurchaseSuccess(
      PurchaseDetails purchaseDetails, Emitter emit) async {
    isCalled = true;
    // Call backend to complete the purchase
    await repo.buySubscription(
      isAndroid: Platform.isAndroid,
      subscriptionName: purchaseDetails.productID,
      purchaseToken: Platform.isAndroid
          ? purchaseDetails.verificationData.serverVerificationData
          : ((purchaseDetails as AppStorePurchaseDetails)
                  .skPaymentTransaction
                  .originalTransaction!
                  .transactionIdentifier ??
              ""),
      productId: purchaseDetails.productID,
      onSuccess: (String message) {
        log('Success on backend');
        emit(state.copyWith(
            loading: false,
            result: Result.successful(message, InitializeSubscriptionEvent())));
      },
      onFailure: (String message) {
        log('Error on backend');
        emit(state.copyWith(
            loading: false,
            result: Result.error(message, InitializeSubscriptionEvent())));
      },
    );
  }

  Future<void> _getUserSubscriptionEvent(
      GetUserSubscriptionEvent event, Emitter emit) async {
    try {
      if (appBloc.state.user.isSubscriptionPaid == false) {
        return;
      }
      emit(state.copyWith(cPLoading: true, result: Result.idle()));
      await repo.getCurrentSubscription(onSuccess: (SubscriptionModel data) {
        print('Got Data');
        emit(state.copyWith(
          currentSubscription: data,
          cPLoading: false,
          result: Result.successful('', event),
        ));
      }, onFailure: (msg) {
        print('Got Failed');

        emit(state.copyWith(
          cPLoading: false,
          result: Result.error(msg, event),
        ));
      });
    } on PlatformException catch (e) {
      print('Got PlatformException');

      emit(state.copyWith(
        cPLoading: false,
        result: Result.error(e.message.toString(), event),
      ));
      log(e.toString());
    } catch (e) {
      print('Got e');

      emit(state.copyWith(
        cPLoading: false,
        result: Result.error("Unknown error occurred", event),
      ));
      log(e.toString());
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel(); // Cancel stream when bloc is closed
    return super.close();
  }
}
