import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController{
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async{
    //custom code when notification gets created
    print('notification created!');
  }
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async{
    //custom code when notification gets displayed
    print('notification displayed!');
  }
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedNotification receivedNotification) async{
    print('notification dismissed!');
  }
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedNotification receivedNotification) async{
    print('notification received!');
  }
}