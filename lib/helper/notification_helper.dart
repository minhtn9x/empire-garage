import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// void listenForNotifications() {
//   // Initialize the Firebase app
//   FirebaseDatabase.instance.setPersistenceEnabled(true);
//   DatabaseReference reference =
//       FirebaseDatabase.instance.ref().child('notifications');

//   // Initialize the FlutterLocalNotificationsPlugin
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   var initializationSettingsAndroid =
//       const AndroidInitializationSettings('@mipmap/ic_launcher');
//   var initializationSettingsIOS = const IOSInitializationSettings();
//   var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//   flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   // Listen for changes in the Firebase Realtime Database
//   reference.onChildAdded.listen((event) async {
//     // Get the notification data from the event snapshot
//     Map<dynamic, dynamic> values =
//         event.snapshot.value as Map<dynamic, dynamic>;
//     String title = values['title'];
//     String message = values['message'];

//     // Define the notification details
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//         'your channel id', 'your channel name', 'your channel description',
//         importance: Importance.high, priority: Priority.high, ticker: 'ticker');
//     var iOSPlatformChannelSpecifics =
//         const IOSNotificationDetails(presentAlert: true, presentBadge: true);
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);

//     // Show the notification
//     await flutterLocalNotificationsPlugin.show(
//         0, title, message, platformChannelSpecifics);
//   });
// }

void sendNotification(int userId, String title, String message) async {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference reference = database.ref('users/$userId/notifications');

  // Push a new notification to the Firebase Realtime Database
  DatabaseReference newNotificationRef = reference.push();
  await newNotificationRef.set({
    'title': title,
    'message': message,
    'time': DateTime.now().toIso8601String(),
    'isRead': "false",
  });
  // Get the unique key for the new notification
  String? newNotificationKey = newNotificationRef.key;
  if (kDebugMode) {
    print('New notification key: $newNotificationKey');
  }
}

void readNotification(String key) async {
  final databaseReference = FirebaseDatabase.instance.ref();
  var userId = await getUserId();
  String notificationId = key;
  databaseReference
      .child('users/$userId/notifications/$notificationId')
      .update({'isRead': "true"}).then((_) {
    if (kDebugMode) {
      print("Title updated successfully!");
    }
  }).catchError((error) {
    if (kDebugMode) {
      print("Failed to update title: $error");
    }
  });
}

Future<int> countNotification() async {
  final ref = FirebaseDatabase.instance.ref();
  var userId = await getUserId();
  final snapshot = await ref.child('users/$userId/notifications').get();
  if (snapshot.exists) {
    var values = snapshot.value as Map<dynamic, dynamic>;
    return values.values
        .where((element) => element['isRead'] == 'false')
        .length;
  }
  return 0;
}
