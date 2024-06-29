import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/thing_provider.dart';
import 'package:things_app/widgets/fromLink/view_thing_from_link.dart';
import 'package:things_app/widgets/things/thing_view.dart';

class ThingsListView extends StatelessWidget {
  const ThingsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThingProvider>(
      builder: (context, thingProvider, child) {
        if (thingProvider.thingFromLink != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Show your dialog here
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ViewThingFromLink(thing: thingProvider.thingFromLink!);
              },
            );
          });
        }

        return ListView.builder(
            itemCount: thingProvider.things.length,
            itemBuilder: (ctx, index) {
              return ThingView(thing: thingProvider.things[index]);
            });
      },
    );
  }
}
