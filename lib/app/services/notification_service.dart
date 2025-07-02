import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:tiki_taka_scoreboard_desktop/match/match.dart';
import 'package:user_api/user_api.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  String _token = '';
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    // Setup Flutter local notifications
    await setupFlutterNotifications();

    // Get MacOS device information
    final macOsInfo = LocalSettingsService.instance.macOsInfo;

    // Get Windows device information
    final windowsInfo = LocalSettingsService.instance.windowsInfo;

    // Get FCM token
    String? token;
    try {
      if (Platform.isMacOS) {
        token = macOsInfo?.systemGUID;
      } else if (Platform.isWindows) {
        token = windowsInfo?.deviceId;
      } else {
        throw FirebaseException(
          plugin: 'device_info_plus',
          message: 'Unsupported platform for FCM token retrieval',
          code: 'unsupported_platform',
        );
      }
    } on FirebaseException catch (e) {
      debugPrint('Error getting FCM token: $e');
    }

    if (token != null) {
      _token = token;
    } else {
      return;
    }

    // Get device locale
    final localLanguage = await LocalSettingsService.instance
        .getLocalLanguage();

    // Get device dark mode
    final darkMode = await LocalSettingsService.instance.getDarkMode();

    // Setup Flutter local notifications
    unawaited(
      FirebaseFirestore.instance.collection(devicesCollection).doc(token).set(
        {
          'token': token,
          'lastOpenAt': FieldValue.serverTimestamp(),
          'androidInfo': null,
          'macOsInfo': macOsInfo?.toJson(),
          'windowsInfo': windowsInfo?.toJson(),
          'language': localLanguage,
          'darkMode': darkMode,
          'enabledTeams': FieldValue.arrayUnion(<String>[]),
        },
        SetOptions(merge: true),
      ),
    );
  }

  String get token => _token;

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const initializationSettingsMacOS = DarwinInitializationSettings();
    const initializationSettingsWindows = WindowsInitializationSettings(
      appName: appName,
      appUserModelId: appUserModelId,
      guid: appGUID,
    );

    const initializationSettings = InitializationSettings(
      macOS: initializationSettingsMacOS,
      windows: initializationSettingsWindows,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) =>
          _handleBackgroundMessage(details.payload ?? ''),
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(AppMessage message) async {
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      const NotificationDetails(
        macOS: DarwinNotificationDetails(),
        windows: WindowsNotificationDetails(),
      ),
      payload: message.data['match'].toString(),
    );
  }

  void _handleBackgroundMessage(String message) {
    debugPrint('Handling a background message: $message');
    if (message.contains('matchId')) {
      final matchId = int.parse(
        message.split('matchId:')[1],
      );
      navigatorKey.currentState
          ?.pushNamed(
            MatchPage.routeName,
            arguments: matchId,
          )
          .ignore();
    }
  }
}

extension MacOsInfo on MacOsDeviceInfo {
  Map<String, dynamic> toJson() {
    return {
      'computerName': computerName,
      'hostName': hostName,
      'arch': arch,
      'model': model,
      'modelName': modelName,
      'kernelVersion': kernelVersion,
      'osRelease': osRelease,
      'majorVersion': majorVersion,
      'minorVersion': minorVersion,
      'patchVersion': patchVersion,
      'activeCPUs': activeCPUs,
      'memorySize': memorySize,
      'cpuFrequency': cpuFrequency,
      'systemGUID': systemGUID,
    };
  }
}

extension WindowsInfo on WindowsDeviceInfo {
  Map<String, dynamic> toJson() {
    return {
      'computerName': computerName,
      'numberOfCores': numberOfCores,
      'systemMemoryInMegabytes': systemMemoryInMegabytes,
      'userName': userName,
      'majorVersion': majorVersion,
      'minorVersion': minorVersion,
      'buildNumber': buildNumber,
      'platformId': platformId,
      'csdVersion': csdVersion,
      'servicePackMajor': servicePackMajor,
      'servicePackMinor': servicePackMinor,
      'suitMask': suitMask,
      'productType': productType,
      'reserved': reserved,
      'buildLab': buildLab,
      'buildLabEx': buildLabEx,
      'digitalProductId': digitalProductId,
      'displayVersion': displayVersion,
      'editionId': editionId,
      'installDate': Timestamp.fromDate(installDate),
      'productId': productId,
      'productName': productName,
      'registeredOwner': registeredOwner,
      'releaseId': releaseId,
      'deviceId': deviceId,
    };
  }
}
