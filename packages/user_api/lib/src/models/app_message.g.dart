// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppMessage _$AppMessageFromJson(Map<String, dynamic> json) => AppMessage(
      senderId: json['senderId'] as String?,
      collapseKey: json['collapseKey'] as String?,
      from: json['from'] as String?,
      messageId: json['messageId'] as String?,
      messageType: json['messageType'] as String?,
      notification: AppNotification.fromJson(
        json['notification'] as Map<String, dynamic>? ?? {},
      ),
      sentTime: (json['sentTime'] as Timestamp? ?? Timestamp.now())
          .toDate()
          .toLocal(),
      data: json['data'] as Map<String, dynamic>? ?? {},
    );
