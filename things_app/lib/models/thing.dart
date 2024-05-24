import 'package:uuid/uuid.dart';

final uuid = const Uuid().v4();

class Thing {
  final String id;
  final String title;
  final String? description;

  const Thing({required this.id, required this.title, required this.description});
  Thing.createWithTitleAndDescription({required this.title, required this.description}) : id = uuid;

  //Map<String, String> get ThingFor
}