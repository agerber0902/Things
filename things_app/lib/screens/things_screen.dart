import 'package:flutter/material.dart';
import 'package:things_app/helpers/firebase_helper.dart';
import 'package:things_app/models/thing.dart';

import 'package:things_app/widgets/add_thing.dart';
import 'package:things_app/widgets/things_list_view.dart';

final ThingsFirebaseHelper _firebaseHelper = ThingsFirebaseHelper();

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

  void _addThing(Thing thingToAdd) async {
    await _firebaseHelper.postThing(thingToAdd);

    _getThings();
  }

  void _deleteThing(Thing thingToDelete) async{
    await _firebaseHelper.deleteThing(thingToDelete);

    _getThings();
  }

  void _getThings() async {
    List<Thing> thingsToReturn = await _firebaseHelper.getThings();
    print('called get things');
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
          : ThingsListView(things: _thingsToDisplay, deleteThing: _deleteThing,),
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