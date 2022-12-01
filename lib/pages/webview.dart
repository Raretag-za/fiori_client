import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';

class AppWebView extends StatefulWidget {
  const AppWebView({Key? key, this.cookieManager, required this.url})
      : super(key: key);
  final CookieManager? cookieManager;
  final String url;

  @override
  State<AppWebView> createState() => _WebViewState();
}

class _WebViewState extends State<AppWebView> {
  bool _isVisible = true;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    } else if (Platform.isIOS) {
      // WebView.platform = WKWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                backgroundColor: Colors.white,
                body: GestureDetector(
                  onTap: () {
                    // print('onTap');
                    _isVisible = true;
                  },
                  onLongPress: () {
                    _isVisible = false;
                  },
                  child: WebView(
                    initialUrl: widget.url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    gestureNavigationEnabled: true,
                    backgroundColor: const Color(0x00000000),
                  ),
                  // floatingActionButton: favoriteButton(),
                ),
                bottomNavigationBar: Offstage(
                  offstage: _isVisible,
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: 0,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.settings),
                        label: 'Settings',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.question),
                        label: 'Help',
                      )
                    ],
                    onTap: (onItemTapped) async {
                      switch (onItemTapped) {
                        case 0:
                          await openAppSettings();
                          break;
                        case 1:
                          break;
                      }
                    },
                  ),
                )
            )
        )
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
