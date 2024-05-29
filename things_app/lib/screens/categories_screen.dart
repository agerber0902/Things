import 'package:flutter/material.dart';
//import 'package:things_app/helpers/firebase_helper.dart';
import 'package:things_app/models/category.dart';
//import 'package:things_app/widgets/categories/add_category.dart';

//CategoryFirebaseHelper _firebaseHelper = CategoryFirebaseHelper();

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // void _addCategory(Category category) {
  //   _firebaseHelper.postCategory(category);

  //   _firebaseHelper.getCategories();
  // }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: textTheme.headlineLarge!.copyWith(color: colorScheme.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (final icon in categoryIcons.entries)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(icon.key),
                                  Icon(icon.value.iconData,
                                      color: icon.value.iconColor),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              //[
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: categoryIcons.length,
              //     itemBuilder: (context, index) {
              //       final iconKey = categoryIcons.keys.elementAt(index);
              //       return Text(iconKey);
              //     },
              //   ),
              // ),
              //],
            ),
          ),
        ),
      ),
    );
  }
}
