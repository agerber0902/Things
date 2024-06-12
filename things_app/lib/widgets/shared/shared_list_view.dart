import 'package:flutter/material.dart';
import 'package:things_app/widgets/shared/shared_card_view.dart';

class SharedListView<T> extends StatelessWidget {
  const SharedListView({super.key, required this.listItems});

  final List<T> listItems;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (ctx, index) {
          return SharedCardView<T>(
            item: listItems[index],
          );
        });
  }
}
