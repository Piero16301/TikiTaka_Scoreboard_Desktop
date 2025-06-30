import 'package:equatable/equatable.dart';

part 'app_notification.g.dart';

/// {@template app_notification}
/// Modelo de notificación.
/// {@endtemplate}
class AppNotification extends Equatable {
  /// {@macro app_notification}
  const AppNotification({
    required this.title,
    required this.body,
    required this.channelId,
    required this.clickAction,
    required this.color,
    required this.count,
    required this.imageUrl,
    required this.priority,
    required this.ticker,
    required this.visibility,
    required this.tag,
  });

  /// Crea una instancia de [AppNotification] a partir de un [Map] json
  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  /// Título de la notificación
  final String title;

  /// Cuerpo de la notificación
  final String body;

  /// Id del canal de la notificación
  final String channelId;

  /// Acción al hacer clic en la notificación
  final String clickAction;

  /// Color de la notificación
  final String color;

  /// Contador de la notificación
  final int count;

  /// URL de la imagen de la notificación
  final String imageUrl;

  /// Prioridad de la notificación
  final NotificationPriority priority;

  /// Ticker de la notificación
  final String ticker;

  /// Visibilidad de la notificación
  final NotificationVisibility visibility;

  /// Etiqueta de la notificación
  final String tag;

  @override
  List<Object?> get props => [
        title,
        body,
        channelId,
        clickAction,
        color,
        count,
        imageUrl,
        priority,
        ticker,
        visibility,
        tag,
      ];
}

/// Prioridades de notificación
enum NotificationPriority {
  /// Prioridad mínima
  minimumPriority,

  /// Prioridad baja
  lowPriority,

  /// Prioridad normal
  defaultPriority,

  /// Prioridad alta
  highPriority,

  /// Prioridad máxima
  maximumPriority,
}

/// Visibilidad de la notificación
enum NotificationVisibility {
  /// Visibilidad pública
  secret,

  /// Visibilidad privada
  private,

  /// Visibilidad pública
  public,
}
