import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:planaholic/models/Event.dart';
import 'package:planaholic/screens/Wrapper.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// A collection of method concerning notification services
class NotifService {
  /// Initialise the notification system
  static void initialise(BuildContext context) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("notebook_logo");

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    /// Helper function that selects a notification from a payload
    Future selectNotification(String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      await Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => Wrapper()),
      );
    }

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  /// Dummy instant notification feature for simple testing
  static void notify() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  /// Add a scheduled notification
  static Future<void> notifyScheduled(Event event, int id, int before) async {
    DateTime startTime = event.startTime.subtract(Duration(minutes: before));
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Singapore"));
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'You have an activity coming!',
        event.category + ": " + event.description + " at " +
            event.startTime.hour.toString() + ":" + event.startTime.minute.toString(),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        tz.TZDateTime(tz.getLocation("Asia/Singapore"),
        startTime.year, startTime.month, startTime.day, startTime.hour, startTime.minute),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  /// Change a scheduled notification
  static Future<void> changeSchedule(int id, Event event, int before) async {
    DateTime startTime = event.startTime.subtract(Duration(minutes: before));
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Singapore"));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'You have an activity coming!',
        event.category + ": " + event.description + " at " +
            event.startTime.hour.toString() + ":" + event.startTime.minute.toString(),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        tz.TZDateTime(tz.getLocation("Asia/Singapore"),
            startTime.year, startTime.month, startTime.day, startTime.hour, startTime.minute),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  /// Delete a scheduled event
  static void deleteSchedule(int id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Delete ALL notifications
  static void deleteAll() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}