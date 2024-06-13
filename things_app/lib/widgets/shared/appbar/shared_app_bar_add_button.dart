import 'package:flutter/material.dart';
import 'package:things_app/providers/provider_helper.dart';

class SharedAppBarAddButton extends StatelessWidget {
  const SharedAppBarAddButton({super.key, required this.modalBottomSheet});

  final Widget modalBottomSheet;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return IconButton(
        onPressed: () {

          //set edit mode in trings provider
          ProviderHelper().setAddThingProviders(context);

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
