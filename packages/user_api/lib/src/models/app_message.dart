import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:user_api/src/models/models.dart';

part 'app_message.g.dart';

/// {@template app_message}
/// Modelo de datos para un mensaje de notificación.
/// {@endtemplate}
class AppMessage extends Equatable {
  /// {@macro app_message}
  const AppMessage({
    required this.senderId,
    required this.collapseKey,
    required this.from,
    required this.messageId,
    required this.messageType,
    required this.notification,
    required this.sentTime,
    this.data = const <String, dynamic>{},
  });

  /// Crea una instancia de [AppMessage] a partir de un [Map] json
  factory AppMessage.fromJson(Map<String, dynamic> json) =>
      _$AppMessageFromJson(json);

  /// Id del remitente del mensaje
  final String? senderId;

  /// Clave de colapso del mensaje
  final String? collapseKey;

  /// Id del remitente del mensaje
  final String? from;

  /// Id del mensaje
  final String? messageId;

  /// Tipo del mensaje
  final String? messageType;

  /// Notificación del mensaje
  final AppNotification? notification;

  /// Fecha y hora en que se envió el mensaje
  final DateTime? sentTime;

  /// Datos del mensaje
  final Map<String, dynamic> data;

  @override
  List<Object?> get props => [
        senderId,
        collapseKey,
        from,
        messageId,
        messageType,
        notification,
        sentTime,
        data,
      ];
}
