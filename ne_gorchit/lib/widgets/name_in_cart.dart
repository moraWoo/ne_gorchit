// import 'package:flutter/material.dart';
// import 'package:ne_gorchit/model/menu.dart';

// class nameInCart extends StatelessWidget {
//   const nameAndDescriptionFoodItem({
//     super.key,
//     required this.item,
//   });

//   final Datum item;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             item.name,
//             style: const TextStyle(
//               fontSize: 26,
//               color: Colors.grey,
//               decoration: TextDecoration.none,
//             ),
//             maxLines: 1,
//           ),
//           const SizedBox(height: 7),
//           Text(
//             item.description,
//             style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.normal,
//                 color: Colors.grey,
//                 decoration: TextDecoration.none),
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }
