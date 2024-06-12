import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:things_app/models/category.dart';
import 'package:things_app/providers/category_provider.dart';
import 'package:things_app/utils/value_utils.dart';

class SelectedCategories extends StatelessWidget {
  const SelectedCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: provider.categories.isEmpty
              ? [
                  Text(
                    ThingsUtils().categoriesValidationText,
                    style:
                        textTheme.bodySmall!.copyWith(color: colorScheme.error),
                  )
                ]
              : provider.categories.map((c) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      color: colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              c,
                              style: textTheme.displaySmall!
                                  .copyWith(fontSize: 18),
                            ),
                            const SizedBox(width: 10),
                            Icon(categoryIcons[c]!.iconData,
                                color: categoryIcons[c]!.iconColor),
                            const SizedBox(width: 5),
                            Opacity(
                              opacity: 0.4,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  provider.deletecategory(c);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
        );
      },
    );
  }
}
