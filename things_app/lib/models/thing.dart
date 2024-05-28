import 'package:uuid/uuid.dart';

final uuid = const Uuid().v4();

class Thing {
  final String id;
  final String title;
  final String? description;

  final List<String> categories;

  const Thing({required this.id, required this.title, required this.description, required this.categories});
  Thing.createWithTitleAndDescription({required this.title, required this.description, required this.categories}) : id = uuid;

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
          description: entry.value['description'],
          categories: entry.value['categories'].split(','),
        );

    return decodedThing;
  }

  Map<String, String?> thingToMap({required Thing thing}){
    final encodedThing = {
      'title': thing.title,
      'description': thing.description,
      'categories': thing.categories.join(','),
    };
    return encodedThing;
  }

}