import 'package:fiori_client/pages/url_entry.dart';
import 'package:fiori_client/pages/webview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class AppManager extends StatelessWidget {
  const AppManager({super.key,required this.home});
  final Widget home;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            // scaffoldBackgroundColor: Colors.orange,
            primaryColor: Colors.orange,
            hoverColor: Colors.orange,
            focusColor: Colors.orange,
            hintColor: Colors.orange),
        home: home);
  }
}
