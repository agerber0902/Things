import 'package:flutter/material.dart';
import 'package:things_app/providers/provider_helper.dart';

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
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    Future<void> dialogBuilder() {
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
      dialogBuilder();
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
        //set add mode for reminder provider
        ProviderHelper().setAddReminderProviders(context);

        //set add mode for reminder provider
        ProviderHelper().setAddThingProviders(context);
        
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
