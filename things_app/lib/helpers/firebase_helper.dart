import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:things_app/models/thing.dart';

class FirebaseHelper {
  final String baseFirebaseUrl = 'things-a-default-rtdb.firebaseio.com';
}

class ThingsFirebaseHelper extends FirebaseHelper {
  final Uri? url = null;
  final String collectionName = 'things-list';

  final headers = {
    'Content-Type': 'application/json',
  };

  ThingsHttpHelper? httpHelper;
  
  ThingsFirebaseHelper() {
    httpHelper = ThingsHttpHelper(headers: headers);
  }

  Uri get getHttpsPostUrl {
    return Uri.https(baseFirebaseUrl, '$collectionName.json');
  }

  Uri get getHttpsGetUrl {
    return Uri.https(baseFirebaseUrl, '$collectionName.json');
  }

  Uri getHttpsDeleteUrl(String id) {
    return Uri.https(baseFirebaseUrl, '$collectionName/$id.json');
  }

  Future<List<Thing>> getThings() async{
    final url = getHttpsGetUrl;

    final response = await httpHelper!.httpGet(url: url);

    final data = json.decode(response.body);

    if(data == null || data.entries == null){
      return [];
    }

    List<Thing> thingsToReturn = ThingJsonHelper().decodedThings(data: data);

    return thingsToReturn;

  }

  Future<void> postThing(Thing thing) async{
    await httpHelper!.httpPost(
      url: getHttpsPostUrl, 
      body: ThingJsonHelper().ThingToMap(thing: thing)
    );
    return;
  }

  Future<void> deleteThing(Thing thing) async{
    await httpHelper!.httpDelete(url: getHttpsDeleteUrl(thing.id));
    return;
  }

}

class ThingsHttpHelper {
  final Map<String, String> headers;

  const ThingsHttpHelper({required this.headers});

  Future<Response> httpPost({required Uri url, required Map<String, String?> body}) async {

    return await http.post(url, headers: headers, body: jsonEncode(body));

  }

  Future<Response> httpGet({required Uri url}) async {

    return await http.get(url);

  }

  Future<Response> httpDelete({required url}) async{

    return await http.delete(url);

  }
}
