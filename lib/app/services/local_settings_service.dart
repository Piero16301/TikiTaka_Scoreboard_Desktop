import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';

class LocalSettingsService {
  LocalSettingsService._();

  static final LocalSettingsService instance = LocalSettingsService._();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late SharedPreferences _preferences;
  late MacOsDeviceInfo? _macOsInfo;
  late WindowsDeviceInfo? _windowsInfo;
  late PackageInfo _packageInfo;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    if (Platform.isMacOS) {
      _macOsInfo = await DeviceInfoPlugin().macOsInfo;
      _windowsInfo = null;
    } else if (Platform.isWindows) {
      _macOsInfo = null;
      _windowsInfo = await DeviceInfoPlugin().windowsInfo;
    } else {
      _macOsInfo = null;
      _windowsInfo = null;
    }
    _packageInfo = await PackageInfo.fromPlatform();
  }

  Future<String> getLocalLanguage() async {
    final localeString = _preferences.getString('__user_language__') ?? 'en_US';

    return localeString;
  }

  Future<bool> getDarkMode() async {
    final darkMode = _preferences.getBool('__user_dark_mode__') ?? false;

    return darkMode;
  }

  void saveLanguageOnFirestore({String language = 'en_US'}) {
    firestore
        .collection(devicesCollection)
        .doc(NotificationService.instance.token)
        .set(
          {
            'language': language,
          },
          SetOptions(merge: true),
        );
  }

  void saveDarkModeOnFirestore({bool darkMode = true}) {
    firestore
        .collection(devicesCollection)
        .doc(NotificationService.instance.token)
        .set(
          {
            'darkMode': darkMode,
          },
          SetOptions(merge: true),
        );
  }

  MacOsDeviceInfo? get macOsInfo {
    return _macOsInfo;
  }

  WindowsDeviceInfo? get windowsInfo {
    return _windowsInfo;
  }

  PackageInfo get packageInfo {
    return _packageInfo;
  }
}
