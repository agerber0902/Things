import 'package:flutter/material.dart';
import 'package:things_app/models/category.dart'; // Make sure this import is correct

class FilterDialog extends StatefulWidget {
  const FilterDialog(
      {super.key,
      required this.availableFilters,
      required this.updateFilters,
      required this.resetFilters, required this.saveFilters});

  final List<Map<MapEntry<String, CategoryIcon>, bool>> availableFilters;
  final void Function(String categoryName, bool switchValue) updateFilters;
  final void Function() resetFilters;
  final void Function(List<Map<MapEntry<String, CategoryIcon>, bool>> filters) saveFilters;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(
        'Filters',
        style: textTheme.displayMedium!.copyWith(color: colorScheme.primary),
      ),
      content: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.availableFilters.map((filter) {
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
                      widget.updateFilters(filter.entries.first.key.key, value);
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
            widget.resetFilters();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Enable'),
          onPressed: () {
            widget.saveFilters(widget.availableFilters);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
