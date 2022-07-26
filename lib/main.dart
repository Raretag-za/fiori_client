import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_build.dart';

final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

Future<void> main() async {
  AppUpdateInfo? updateInfo;
  WidgetsFlutterBinding.ensureInitialized();

  // InAppUpdate.checkForUpdate().then((info) {
  //   updateInfo = info;
  //   if (updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
  //     // runApp(UpdateManager());
  //     InAppUpdate.performImmediateUpdate().catchError((e) {});
  //   } else {
  //     runApp(AppManager());
  //   }
  // }).catchError((e) {});
  runApp(AppManager());
}
