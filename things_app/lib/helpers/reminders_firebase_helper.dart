import 'dart:convert';

import 'package:things_app/helpers/firebase_helper.dart';
import 'package:things_app/models/reminder.dart';

class RemindersFirebaseHelper extends FirebaseHelper {
  final Uri? url = null;
  final String collectionName = 'reminders-list';

  final headers = {
    'Content-Type': 'application/json',
  };

  HttpHelper? httpHelper;
  
  RemindersFirebaseHelper() {
    httpHelper = HttpHelper(headers: headers);
  }

  Uri get getHttpsPostUrl {
    return Uri.https(baseFirebaseUrl, '$collectionName.json');
  }

  Uri getHttpsPutUrl(String id) {
    return Uri.https(baseFirebaseUrl, '$collectionName/$id.json');
  }

  Uri get getHttpsGetUrl {
    return Uri.https(baseFirebaseUrl, '$collectionName.json');
  }

  Uri getHttpsDeleteUrl(String id) {
    return Uri.https(baseFirebaseUrl, '$collectionName/$id.json');
  }

  Future<List<Reminder>> getReminders() async{
    final url = getHttpsGetUrl;

    final response = await httpHelper!.httpGet(url: url);

    final data = json.decode(response.body);

    if(data == null || data.entries == null){
      return [];
    }

    List<Reminder> remindersToReturn = ReminderJsonHelper().decodedReminders(data: data);

    return remindersToReturn;

  }

  Future<void> postReminder(Reminder reminder) async{
    await httpHelper!.httpPost(
      url: getHttpsPostUrl, 
      body: ReminderJsonHelper().reminderToMap(reminder: reminder)
    );
    return;
  }

  Future<void> putReminder(Reminder reminder) async{
    await httpHelper!.httpPut(
      url: getHttpsPutUrl(reminder.id), 
      body: ReminderJsonHelper().reminderToMap(reminder: reminder)
    );
    return;
  }

  Future<void> deleteReminder(Reminder reminder) async{
    await httpHelper!.httpDelete(url: getHttpsDeleteUrl(reminder.id));
    return;
  }

}
