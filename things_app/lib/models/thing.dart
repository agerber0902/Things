import 'package:uuid/uuid.dart';

final uuid = const Uuid().v4();

class Thing {
  final String id;
  final String title;
  final String? description;
  bool isMarkedComplete;

  final List<String> categories;

  List<String>? notes;

  bool get notesExist {
    return notes != null && notes!.isNotEmpty;
  }

  bool get categoriesContainsFavorite {
    return categories.contains('favorite');
  }

  Thing(
      {required this.id,
      required this.title,
      required this.description,
      required this.categories,
      required this.isMarkedComplete, this.notes});
  Thing.createWithTitleAndDescription(
      {required this.title,
      required this.description,
      required this.categories,
      required this.isMarkedComplete, this.notes})
      : id = uuid;
}

class ThingJsonHelper {
  List<Thing> decodedThings({required data}) {
    List<Thing> thingsToReturn = [];
    for (final MapEntry<String, dynamic> entry in data.entries) {
      thingsToReturn.add(decodedThing(entry: entry));
    }

    return thingsToReturn;
  }

  Thing decodedThing({required entry}) {
    bool isComplete;

    if (entry.value['isMarkedComplete'] is bool) {
      isComplete = entry.value['isMarkedComplete'];
    } else if (entry.value['isMarkedComplete'] is String) {
      isComplete = entry.value['isMarkedComplete'] == 'true';
    } else {
      // Handle unexpected types or null values
      isComplete = false; // or handle appropriately
    }

    final decodedThing = Thing(
      id: entry.key,
      title: entry.value['title'],
      description: entry.value['description'],
      categories: entry.value['categories'].split(','),
      isMarkedComplete: isComplete,
      notes: entry.value['notes']?.split(';'),
    );

    //pass null for notes if it has one empty note
    if (decodedThing.notes?.length == 1 && decodedThing.notes!.first.isEmpty){
      decodedThing.notes = null;
    }

    return decodedThing;
  }

  Map<String, String?> thingToMap({required Thing thing}) {
    final encodedThing = {
      'title': thing.title,
      'description': thing.description,
      'categories': thing.categories.join(','),
      'isMarkedComplete': thing.isMarkedComplete.toString(),
      'notes': thing.notes?.join(';'),
    };
    return encodedThing;
  }
}
