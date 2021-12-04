import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class LocalNotif {
  static final _notifaction = FlutterLocalNotificationsPlugin();
  static final onNotifActions = BehaviorSubject<String?>();

  static Future init({bool initSchedule = false}) async {
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: ios);

    await _notifaction.initialize(initSettings,
        onSelectNotification: (payload) async {
      onNotifActions.add(payload);
      print('onSelectNotification');
    });
  }

  static Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        title, title,
        channelDescription: body,
        importance: Importance.high,
        priority: Priority.max);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await _notifaction.show(0, title, body, platformChannelSpecifics,
        payload: 'item x');
  }
}
