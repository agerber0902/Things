// import 'package:flutter/material.dart';
// import 'package:things_app/models/category.dart';

// const String nameHintText = 'Enter a name';
// const String nameValidationText = 'Enter a valid name';

// const String descriptionHintText = 'Enter a short description';
// const String descriptionValidationText = 'Enter a valid description';

// const Map<String, IconData> iconMapping = {
//     'favorite': Icons.favorite,
//     'house': Icons.home,
//     'settings': Icons.settings,
//     'restaurants': Icons.dining,
//     'recipes': Icons.restaurant,
//     'chores': Icons.agriculture_sharp,
//   };

// class AddCategory extends StatefulWidget {
//   const AddCategory({
//     super.key,
//     required this.addCategory,
//   });

//   final void Function(Category category) addCategory;

//   @override
//   State<AddCategory> createState() => _AddCategoryState();
// }

// class _AddCategoryState extends State<AddCategory> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameTextController = TextEditingController();

//   String _dropdownValue = iconMapping.entries.first.key;

//   @override
//   void dispose() {
  // _nameTextController.dispose();
//     super.dispose();
//     
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 400,
//       width: double.infinity,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 padding: const EdgeInsets.all(8),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.close),
//               ),
//             ],
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Form(
//                     key: _formKey,
//                     child: Expanded(
//                       child: Column(
//                         children: [
//                           AddCategoryTextFormField(
//                             controller: _nameTextController,
//                             hintText: nameHintText,
//                             validationText: nameValidationText,
//                             maxLength: 25,
//                             maxLines: 1,
//                           ),
//                           const SizedBox(height: 16),
//                           DropdownMenu<String>(
//                             initialSelection: iconMapping.entries.first.key,
//                             onSelected: (value) {
//                               setState(() {
//                                 _dropdownValue = value!;
//                               });
//                             },
//                             dropdownMenuEntries: iconMapping.entries
//                                 .map((value) {
//                               return DropdownMenuEntry<String>(
//                                   value: value.key, label: value.key, leadingIcon: Icon(value.value));
//                             }).toList(),
//                           ),
//                           const SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 final categoryToAdd = Category(
//                                     name: _nameTextController.text,
//                                     iconName: _dropdownValue);

//                                 widget.addCategory(categoryToAdd);

//                                 Navigator.pop(context);
//                               }
//                             },
//                             child: const Text('Add'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AddCategoryTextFormField extends StatelessWidget {
//   const AddCategoryTextFormField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     required this.validationText,
//     required this.maxLength,
//     required this.maxLines,
//   });

//   final TextEditingController controller;
//   final String hintText;
//   final String validationText;
//   final int maxLength;
//   final int maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(10),
//       margin: const EdgeInsets.only(left: 10, right: 10),
//       child: TextFormField(
//         maxLength: maxLength,
//         maxLines: maxLines,
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: hintText,
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return validationText;
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
