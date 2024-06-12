import 'package:flutter/material.dart';

class SharedAppBarAddButton extends StatelessWidget {
  const SharedAppBarAddButton({super.key, required this.modalBottomSheet});

  final Widget modalBottomSheet;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return IconButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) {
                return modalBottomSheet;
              });
        },
        icon: Icon(
          Icons.add,
          color: colorScheme.primary,
        ));
  }
}
