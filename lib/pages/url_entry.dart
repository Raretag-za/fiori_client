import 'dart:developer';
import 'dart:io';
import 'package:fiori_client/pages/qr_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class URLEntry extends StatefulWidget {
  const URLEntry({Key? key}) : super(key: key);

  static const String urlKey = 'url';

  @override
  State<URLEntry> createState() => _URLEntryState();
}

class _URLEntryState extends State<URLEntry> {
  late final TextEditingController url;
  late final dynamic _formKey;
  late bool isTouchLocked;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Widget body;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    url = TextEditingController();
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
                            // ListTile(
                            //   title: Container(
                            //     padding: const EdgeInsets.all(15.0),
                            //     margin: const EdgeInsets.all(15.0),
                            //     child: const Text(
                            //         'Press continue to scan SAP fiori URL QR code provided by your IT administrator',
                            //       style: TextStyle(
                            //           fontSize: 14.0,
                            //           color: Colors.deepOrange,
                            //           fontWeight: FontWeight.w400,
                            //           fontStyle: FontStyle
                            //               .italic /*,fontSize: double.minPositive*/) /*, textScaleFactor: double.minPositive*/,
                            //     ),
                            //   ),
                            //   // isThreeLine: true,
                            // ),
                            TextField(
                              controller: url,
                              decoration: InputDecoration(
                                labelText: 'Enter SAP FIORI URL',
                                prefixIcon: IconButton(
                                  onPressed: (){  
                                    Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const ScanCode(),
                                    ),
                                  );},
                                  icon: const Icon(Icons.qr_code)
                                ),
                                suffixIcon: IconButton(
                                  onPressed: url.clear,
                                  icon: const Icon(Icons.clear),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ScanCode(),
                    ),
                  );
                },
                label: const Text('Continue'),
                icon: const Icon(Icons.arrow_forward),
                // backgroundColor: Colors.pink,
              )),
        ),
      ),
    );
  }
}
