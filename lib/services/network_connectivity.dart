import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:second_shot/presentation/components/custom_snackbar.dart';

class InternetConnectionChecker {
  late StreamSubscription<List<ConnectivityResult>> subscription;

  // @override
  void checkConnectivity(BuildContext context) {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      if (result.first == ConnectivityResult.none) {
        Future.delayed(const Duration(milliseconds: 500), () {
          SnackbarsType.error(
              context, 'No Internet connection, Please connect to the Internet',
              duration: const Duration(seconds: 20));
        });
      } else if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.ethernet)) {
        bool isConnectionWorking = await checkInternetAccess();
        if (!isConnectionWorking) {
          SnackbarsType.error(
              context, 'No Internet connection, Please connect to the Internet',
              duration: const Duration(seconds: 20));
        } else {
          print('Internet connection is working');
        }
      }
    });
  }

  Future<bool> checkInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 30));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
