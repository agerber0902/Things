import 'package:flutter/material.dart';

class SharedAppBarButton extends StatelessWidget {
  const SharedAppBarButton(
      {super.key,
      required this.icon,
      this.isModal,
      this.isBottomSheet,
      required this.displayWidget});

  final bool? isModal;
  final bool? isBottomSheet;
  final Widget displayWidget;
  //TODO: make color colorscheme.primary
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    Future<void> _dialogBuilder() {
      return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return displayWidget;
            });
          });
    }

    void onPressedModal() {
      _dialogBuilder();
    }

    void onPressedBottomSheet() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (ctx) {
            return displayWidget;
          });
    }

    return IconButton(
      onPressed: () {
        //TODO: verify we need this
        //set edit mode in trings provider
        //ProviderHelper().setAddThingProviders(context);

        if(isModal ?? false){
          onPressedModal();
          return;
        }
        if(isBottomSheet ?? false){
          onPressedBottomSheet();
          return;
        }
      },
      icon: icon,
    );
  }
}
