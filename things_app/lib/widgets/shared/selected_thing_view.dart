// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:things_app/providers/thing_reminder_provider.dart';

// class SelectedThingView extends StatelessWidget {
//   const SelectedThingView({super.key,});

//   @override
//   Widget build(BuildContext context) {
//     final TextTheme textTheme = Theme.of(context).textTheme;
//     final ColorScheme colorScheme = Theme.of(context).colorScheme;

//     return Consumer<ThingReminderProvider>(
//       builder: (context, provider, child) {
//         return Visibility(
//           visible: provider.thingRemindersExist && provider.thingRemindersWithThings.isNotEmpty,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: provider.thingRemindersWithThings.map((tr) {
//               return Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Card(
//                   color: colorScheme.primaryContainer,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           tr.thing!.title,//we know things wont be null here with provider check
//                           style: textTheme.displaySmall!.copyWith(fontSize: 18),
//                         ),
//                         const SizedBox(width: 5),
//                         Opacity(
//                           opacity: 0.4,
//                           child: IconButton(
//                             icon: const Icon(Icons.close),
//                             onPressed: () {
//                               provider.delete(tr);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }
// }
