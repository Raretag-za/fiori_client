import 'dart:developer';
import 'dart:io';
import 'package:fiori_client/pages/qr_scan.dart';
import 'package:fiori_client/pages/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class URLEntry extends StatefulWidget {
  String url;

  URLEntry({Key? key, required this.url}) : super(key: key);
  static const String urlKey = 'url';

  @override
  State<URLEntry> createState() => _URLEntryState();
}

class _URLEntryState extends State<URLEntry> {
  TextEditingController urlController = TextEditingController();
  late final dynamic _formKey;
  late bool isTouchLocked;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Widget body;
  bool _validate = false;

  editUrl() {
    widget.url = urlController.text;
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    urlController.text = widget.url;
    urlController.addListener(editUrl);
    isTouchLocked = false;
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => true,
        child: AbsorbPointer(
          absorbing: false /*isTouchLocked*/,
          child: Scaffold(
              // backgroundColor: Colors.grey.shade300,
              extendBodyBehindAppBar: true,
              body: Container(
                padding: const EdgeInsets.symmetric(
                  // vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 50.0,
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                              child: SizedBox(
                                height: 150.0,
                                width: 150.0,
                                child: Image.asset('assets/images/cj.png'),
                              ),
                            ),
                            const Text(
                              "Fiori Client",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            const Center(
                              child: Text(
                                'Please enter SAP Fiori URL or tap icon to scan QR code provided by your IT administrator',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                    fontSize: 10.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // isThreeLine: true,
                            // ),
                            TextField(
                              minLines: 1,
                              maxLines: 5,
                              controller: urlController,
                              decoration: InputDecoration(
                                labelText: 'URL',
                                errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                prefixIcon: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ScanCode(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.qr_code)),
                                suffixIcon: IconButton(
                                  onPressed: urlController.clear,
                                  icon: const Icon(Icons.clear),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                preferences.then((SharedPreferences prefs) {
                                  if (urlController.text.isEmpty) {
                                    setState(() {
                                      urlController.text.isEmpty ? _validate = true : _validate = false;
                                    });
                                  } else {
                                    prefs.setString(
                                        ScanCode.urlKey, widget.url);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AppWebView(url: widget.url)),
                                      (Route<dynamic> route) => false,
                                    );
                                    setState(() {
                                    });
                                  }
                                });
                              },
                              child: const Text("Continue"),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  navigateToWebView() async {}
}
