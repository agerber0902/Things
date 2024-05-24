import 'package:uuid/uuid.dart';

final uuid = const Uuid().v4();

class Thing {
  final String id;
  final String title;
  final String? description;

  const Thing({required this.id, required this.title, required this.description});
  Thing.createWithTitleAndDescription({required this.title, required this.description}) : id = uuid;

}

class ThingJsonHelper{
  List<Thing> decodedThings({required data}){

    List<Thing> thingsToReturn = [];
    for (final entry in data.entries) {
      thingsToReturn.add(decodedThing(entry: entry));
    }

    return thingsToReturn;
  }

  Thing decodedThing({required entry}){

    final decodedThing = Thing(
          id: entry.key,
          title: entry.value['title'],
          description: entry.value['description']
        );

    return decodedThing;
  }

  Map<String, String?> ThingToMap({required Thing thing}){
    final encodedThing = {
      'title': thing.title,
      'description': thing.description,
    };
    return encodedThing;
  }

}