import 'package:flutter/material.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/widgets/things/thing_view.dart';

class ViewThingFromLink extends StatelessWidget {
  const ViewThingFromLink({Key? key, required this.thing}) : super(key: key);

  final Thing thing;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Shared Thing',
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontSize:
                  Theme.of(context).textTheme.displaySmall!.fontSize! - 15.0,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ThingCard(thing: thing),
          ],
        ),
      ),
    );
  }
}
