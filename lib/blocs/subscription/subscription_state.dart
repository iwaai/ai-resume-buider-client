part of 'subscription_bloc.dart';

class SubscriptionState {
  final bool loading;
  final bool cPLoading;
  final bool isAvailable;
  final Result? result;
  final List<ProductDetails> products;
  final ProductDetails? selectedPlan;
  final SubscriptionModel? currentSubscription;

  SubscriptionState(
      {this.loading = false,
      this.cPLoading = false,
      this.isAvailable = false,
      required this.result,
      this.selectedPlan,
      this.currentSubscription,
      this.products = const <ProductDetails>[]});

  factory SubscriptionState.idle() {
    return SubscriptionState(result: Result.idle());
  }

  SubscriptionState copyWith(
      {bool? loading,
      bool? cPLoading,
      bool? isAvailable,
      Result? result,
      ProductDetails? selectedPlan,
      List<ProductDetails>? products,
      SubscriptionModel? currentSubscription}) {
    return SubscriptionState(
        result: result,
        loading: loading ?? this.loading,
        cPLoading: cPLoading ?? this.cPLoading,
        selectedPlan: selectedPlan ?? this.selectedPlan,
        isAvailable: isAvailable ?? this.isAvailable,
        products: products ?? this.products,
        currentSubscription: currentSubscription ?? this.currentSubscription);
  }
}
