import 'package:fiori_client/pages/webview.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ScanCode extends StatefulWidget {


  const ScanCode({Key? key}) : super(key: key);
  static const String urlKey = 'url';
  @override
  State<ScanCode> createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Scan QR code')),
      body: MobileScanner(
          allowDuplicates: false,
          controller: MobileScannerController(
              facing: CameraFacing.back, torchEnabled: false),
          onDetect: (barcode, args) {
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;
              saveURL(code);
            }
          }),
    );
  }

  saveURL(String url) async {
    preferences.then((SharedPreferences prefs) {
      prefs.setString(ScanCode.urlKey, url);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppWebView(url: url))
      );
      setState(() {});
    });
  }
}
