import 'package:flutter/material.dart';
import 'package:second_shot/presentation/components/components_barrels.dart';
import 'package:second_shot/utils/constants/app_url.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermAndConditionScreen extends StatefulWidget {
  const TermAndConditionScreen({super.key});

  @override
  State<TermAndConditionScreen> createState() => _TermAndConditionScreenState();
}

class _TermAndConditionScreenState extends State<TermAndConditionScreen> {
  int progress = 0;

  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int p) {
            progress = p;
            setState(() {});
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(AppUrl.termsLink));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
        child: Scaffold(
      appBar: const CustomAppBar(
        title: "Terms & Conditions",
      ),
      body: progress < 100
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Text('Loading: $progress%')
                ],
              ),
            )
          : WebViewWidget(controller: controller),
    ));
  }
}
