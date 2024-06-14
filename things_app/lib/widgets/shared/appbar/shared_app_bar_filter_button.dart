import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/things_provider.dart';
import 'package:things_app/widgets/shared/filter_dialog.dart';

class SharedAppBarFilterButton extends StatelessWidget {
  const SharedAppBarFilterButton({super.key});

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return const FilterDialog();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    void openFilters() {
      _dialogBuilder(context);
    }

    return Consumer<ThingsProvider>(
      builder: (context, thingsProvider, child) {
        return IconButton(
          onPressed: () {
            openFilters();
          },
          icon: thingsProvider.filterIcon,
        );
      },
    );
  }
}
