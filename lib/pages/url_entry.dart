import 'dart:developer';
import 'dart:io';
import 'package:fiori_client/pages/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    body = form();
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
        onWillPop: () async => false,
        child: AbsorbPointer(
          absorbing: false/*isTouchLocked*/,
          child: Scaffold(
            // backgroundColor: Colors.grey.shade300,
            extendBodyBehindAppBar: true,
            body: Container(
                padding: const EdgeInsets.symmetric(
                    // vertical: 10.0,
                    horizontal: 20.0,
                ),
                child: body,

            ),
          ),
        ),
      ),
    );
  }


  Widget form() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 50.0,),
        Expanded(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: SizedBox(
                    height: 100.0,
                    width: 100.0,
                    // padding: const EdgeInsets.fromLTRB(1, 50, 50, 30),
                    child:
                    Image.asset('assets/images/cj.png'),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          // icon: Icon(Icons.web),
                          labelText: 'Enter URL',
                        ),
                        autofocus: true,
                        controller: url,
                        validator: (f) {
                          if (f!.isEmpty) {
                            return 'Please Enter A URL';
                          }
                        },
                        onEditingComplete: () => validateForm(),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  // padding: const EdgeInsets.all(15.0),
                  // margin: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.deepOrange,
                      )
                  ),
                  child:  ListTile(
                    title: Container(
                      // padding: const EdgeInsets.all(15.0),
                      // margin: const EdgeInsets.all(15.0),
                      child: const Text(
                          'Enter the SAP fiori url as indicated from your IT administrator',style: TextStyle(fontWeight: FontWeight.w100,fontStyle: FontStyle.italic/*,fontSize: double.minPositive*/)/*, textScaleFactor: double.minPositive*/,),
                    ),
                    // isThreeLine: true,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(20.0),
                  ),
                  child: const Text('Continue'),
                  onPressed: () => url.text.isNotEmpty
                      ? validateForm()
                      : ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Row(
                          children: const [
                            Icon(CupertinoIcons.exclamationmark,
                              // color: Colors.red,
                            ),
                            Text('Type in URL first or scan QR code'),
                          ],
                        ),)
                  ),
                ),
                // const SizedBox(
                //   height: 10.0,
                // ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(20.0),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text('Cancel',style: TextStyle(color: Colors.black),),
                  onPressed: () => exit(0),
                ),
                const Spacer(),
                Flexible(
                    child: SizedBox(
                  height: 90,
                  width: 90,
                  child: Image.asset('assets/images/sap.jpg'),)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 50.0,),
      ],
    );
  }

  validateForm() {
    if (_formKey.currentState!.validate()) {
      saveURL();
    }
  }

  saveURL() async {
      preferences.then((SharedPreferences prefs) {
        return (prefs.setString(URLEntry.urlKey, url.text));
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AppWebView()));
      setState(() {
        // body =
      });
  }
}
