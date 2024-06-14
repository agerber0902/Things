import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/providers/things_provider.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({
    super.key,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<ThingsProvider>(
      builder: (context, thingsProvider, child) {
        return AlertDialog(
          title: Text(
            'Filters',
            style:
                textTheme.displayMedium!.copyWith(color: colorScheme.primary),
          ),
          content: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: thingsProvider.availableFilters.map((filter) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          filter.entries.first.key.value.iconData,
                          color: filter.entries.first.key.value.iconColor,
                        ),
                        const SizedBox(width: 5),
                        Text(filter.entries.first.key.key,
                            style: textTheme.labelLarge),
                      ],
                    ),
                    Switch(
                      value: filter.entries.first.value,
                      onChanged: (value) {
                        setState(() {
                          thingsProvider.updateFilters(
                              filter.entries.first.key.key, value);
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Reset'),
              onPressed: () {
                thingsProvider.resetFilters();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                thingsProvider.saveFilters();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
