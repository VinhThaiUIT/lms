//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../components/custom_app_bar.dart';
import '../../../utils/styles.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:http_server/http_server.dart' as http_server;

class VideoWebView extends StatefulWidget {
  final String url;
  final bool isOnline;
  const VideoWebView({
    super.key,
    required this.url,
    required this.isOnline,
  });

  @override
  State<VideoWebView> createState() => _VideoWebViewState();
}

class _VideoWebViewState extends State<VideoWebView> {
  late InAppWebViewController webView;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Builder(builder: (context) {
            if (!widget.isOnline) {
              return Center(
                child: Text(
                  'H5P is only available in online mode',
                  style: robotoRegular.copyWith(fontSize: 14),
                ),
              );
            }
            return InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(widget.url),
              ),
              initialSettings: InAppWebViewSettings(
                useOnDownloadStart: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                javaScriptEnabled: true,
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
            );
          }),
        ));
  }
}
