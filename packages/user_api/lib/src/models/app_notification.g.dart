// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    AppNotification(
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      channelId: json['channelId'] as String? ?? '',
      clickAction: json['clickAction'] as String? ?? '',
      color: json['color'] as String? ?? '',
      count: (json['count'] as num? ?? 0).toInt(),
      imageUrl: json['imageUrl'] as String? ?? '',
      priority: json['priority'] != null
          ? NotificationPriority.values.firstWhere(
              (e) =>
                  e.name.toUpperCase() ==
                  json['priority'].toString().replaceAll('_', '').toUpperCase(),
              orElse: () => NotificationPriority.defaultPriority,
            )
          : NotificationPriority.defaultPriority,
      ticker: json['ticker'] as String? ?? '',
      visibility: json['visibility'] != null
          ? NotificationVisibility.values.firstWhere(
              (e) =>
                  e.name.toUpperCase() ==
                  json['visibility'].toString().toUpperCase(),
              orElse: () => NotificationVisibility.public,
            )
          : NotificationVisibility.public,
      tag: json['tag'] as String? ?? '',
    );
