import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tiki_taka_scoreboard_desktop/app/app.dart';
import 'package:tiki_taka_scoreboard_desktop/match/match.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String _token = '';
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await _requestPermission();

    // Setup message handlers
    await _setupMessageHandlers();

    // Setup Flutter local notifications
    await setupFlutterNotifications();

    // Get FCM token
    String? token;
    try {
      // Get APNs token
      if (Platform.isMacOS || Platform.isWindows) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          debugPrint('APNs Token: $apnsToken');
        } else {
          await Future<void>.delayed(const Duration(seconds: 3));
          final apnsToken = await _messaging.getAPNSToken();
          if (apnsToken != null) {
            debugPrint('APNs Token: $apnsToken');
          } else {
            debugPrint('No APNs token found after delay');
          }
        }
      }
      token = await _messaging.getToken();
      debugPrint('FCM Token: $token');
    } on FirebaseException catch (e) {
      debugPrint('Error getting FCM token: $e');
    }

    if (token != null) {
      _token = token;
    } else {
      return;
    }

    // Get MacOS device information
    final macOsInfo = LocalSettingsService.instance.macOsInfo;

    // Get Windows device information
    final windowsInfo = LocalSettingsService.instance.windowsInfo;

    // Get device locale
    final localLanguage = await LocalSettingsService.instance
        .getLocalLanguage();

    // Get device dark mode
    final darkMode = await LocalSettingsService.instance.getDarkMode();

    // Setup Flutter local notifications
    await FirebaseFirestore.instance
        .collection(notDevicesCollection)
        .doc(token)
        .set(
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
        );

    // Subscribe to AllDevices topic
    await subscribeToTopic(allDevicesTopic);

    if (Platform.isMacOS) {
      // Subscribe to MacOS topic
      await subscribeToTopic(macOSTopic);
    } else if (Platform.isWindows) {
      // Subscribe to Windows topic
      await subscribeToTopic(windowsTopic);
    }
  }

  String get token => _token;

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission();

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        debugPrint('User granted permission');
      case AuthorizationStatus.denied:
        debugPrint('User denied permission');
      case AuthorizationStatus.provisional:
        debugPrint('User granted provisional permission');
      case AuthorizationStatus.notDetermined:
        debugPrint('User has not yet made a choice');
    }
  }

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

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            playSound: false,
            icon: '@mipmap/ic_logo',
          ),
        ),
        payload: message.data['match'].toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    // Foreground message handler
    FirebaseMessaging.onMessage.listen(showNotification);

    // Background message handler
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleBackgroundMessage(message.data['match'] as String? ?? '');
    });

    // Opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage.data['match'] as String? ?? '');
    }
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

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
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
