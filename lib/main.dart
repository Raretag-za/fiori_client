import 'dart:io';

import 'package:fiori_client/pages/url_entry.dart';
import 'package:fiori_client/pages/webview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_build.dart';

final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await checkUpdates();
  }
  preferences.then((value) {
    Widget home;
    String? url = value.getString('url');
    if (url == null || url == '') {
      home = URLEntry(url: '');
    } else {
      home = AppWebView(url: url);
    }
    runApp(AppManager(home: home));
  });
}

checkUpdates() async {
  AppUpdateInfo? updateInfo;
  await InAppUpdate.checkForUpdate().then((info) {
    updateInfo = info;
    if (updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate().catchError((e) {});
    }
  }).catchError((e) {
    if (kDebugMode) {
      print(e.toString());
    }
  });
}
