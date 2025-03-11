import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../components/custom_app_bar.dart';

class ScormViewer extends StatefulWidget {
  final String? uid;
  final String scormContentPath;

  const ScormViewer({super.key, required this.scormContentPath, this.uid});

  @override
  State<ScormViewer> createState() => _ScormViewerState();
}

class _ScormViewerState extends State<ScormViewer> {
  late InAppWebViewController webView;
  String url = "";

  @override
  void initState() {
    if (widget.uid != null) {
      url = "${widget.scormContentPath}?userid=${widget.uid}";
    } else {
      url = widget.scormContentPath;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(url),
          ),
          initialSettings: InAppWebViewSettings(
            useOnDownloadStart: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            javaScriptEnabled: true,
          ),
          onWebViewCreated: (InAppWebViewController controller) async {
            webView = controller;
            await InAppWebViewController.clearAllCache();
            webView.loadUrl(
              urlRequest: URLRequest(
                url: WebUri(url),
              ),
            );
          },
          onLoadStop: (controller, url) async {},
          onConsoleMessage: (controller, consoleMessage) {
            if (kDebugMode) {
              print('Console message: ${consoleMessage.message}');
            }
          },
          onReceivedError: (controller, request, error) {
            // Check error contain ERR_INTERNET_DISCONNECTED
            if (error.description.contains('ERR_INTERNET_DISCONNECTED')) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No internet connection'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
