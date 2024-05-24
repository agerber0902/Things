import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:things_app/models/thing.dart';

import 'package:http/http.dart' as http;
import 'package:things_app/widgets/add_thing.dart';

final String kBaseFirebaseUrl = 'things-a-default-rtdb.firebaseio.com';

class ThingsScreen extends StatefulWidget {
  const ThingsScreen({super.key});

  @override
  State<ThingsScreen> createState() => _ThingsScreenState();
}

class _ThingsScreenState extends State<ThingsScreen> {
  List<Thing> _thingsToDisplay = [];

  @override
  void initState() {
    super.initState();

    //Get things calls set state and updates _thingsToDisplay
    _getThings();
  }

  void _addThing(Thing thingToAdd) {
    _addThingToFirebase(thingToAdd);
  }

  Future<void> _addThingToFirebase(Thing thingToAdd) async {
    final Uri url = Uri.https(kBaseFirebaseUrl, 'things-list.json');

    //We dont need the response at this point, but setting it anyway
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': thingToAdd.title,
        'description': thingToAdd.description,
      }),
    );

    _getThings();
  }

  void _getThings() async {
    //Call Firebase to get things list
    final Uri url = Uri.https(kBaseFirebaseUrl, 'things-list.json');
    final response = await http.get(url);

    final data = json.decode(response.body);

    if(data.entries == null){
      setState(() {
        _thingsToDisplay = [];
      });
      return;
    }

    List<Thing> thingsToReturn = [];
    for (final d in data.entries) {
      thingsToReturn.add(Thing(
          id: d.key,
          title: d.value['title'],
          description: d.value['description']));
    }

    setState(() {
      _thingsToDisplay = thingsToReturn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Things'),
        actions: [
          //None at this time.
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return AddThing(addThing: _addThing,);
                    });
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: _thingsToDisplay.isEmpty
          ? const NoThingsView()
          : Placeholder()//ThingsListView(things: _thingsToDisplay),
    );
  }
}

class NoThingsView extends StatelessWidget {
  const NoThingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No things!'),
        ],
      ),
    );
  }
}