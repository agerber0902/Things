import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/providers/things_provider.dart';
import 'package:things_app/widgets/shared/appbar/collapsable_search_bar.dart';
import 'package:things_app/widgets/shared/appbar/shared_app_bar.dart';
import 'package:things_app/widgets/shared/appbar/shared_app_bar_add_button.dart';
import 'package:things_app/widgets/shared/appbar/shared_app_bar_filter_button.dart';
import 'package:things_app/widgets/shared/shared_drawer.dart';
import 'package:things_app/widgets/shared/shared_list_view.dart';
import 'package:things_app/widgets/things/add/add_thing.dart';
import 'package:things_app/widgets/things/no_things_view.dart';

class ThingsScreen extends StatelessWidget {
  const ThingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppBar(
        title: 'Things',
        actions: [
          CollapsableSearchBar(expandedWidth: 200),
          SharedAppBarFilterButton(),
          SharedAppBarAddButton(
            modalBottomSheet: AddThing(),
          ),
        ],
      ),
      drawer: const SharedDrawer(),
      body: Consumer<ThingsProvider>(
        builder: (context, provider, child) {
          return provider.things.isEmpty
              ? const NoThingsView()
              : SharedListView<Thing>(listItems: provider.things);
        },
      ),
    );
  }
}
