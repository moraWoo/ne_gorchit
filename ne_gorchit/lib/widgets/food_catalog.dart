// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ne_gorchit/controller/controller.dart';
// import 'package:ne_gorchit/model/menu.dart';
// import 'package:http/http.dart' as http;
// import 'package:ne_gorchit/services/network_manager.dart';
// import 'package:ne_gorchit/services/sql_service.dart';
// import 'package:ne_gorchit/widgets/food_menu/bottom_bar.dart';
// import 'package:ne_gorchit/widgets/food_item.dart';
// import 'package:ne_gorchit/widgets/name_description.dart';

// class FoodMenu extends StatefulWidget {
//   FoodMenu({
//     super.key,
//   });

//   @override
//   State<FoodMenu> createState() => _FoodMenuState();
// }

// class SetValues {
//   final bool value;
//   final int count;
//   SetValues(this.value, this.count);
// }

// class _FoodMenuState extends State<FoodMenu> {
//   bool _visibleOfBottomBar = false;
//   int _count = 0;
//   final HomePageController controller = Get.put(HomePageController());
//   SQLService sqlService = SQLService();
//   int countFromDB = 0;
//   List<Datum> itemsDatum = [];

//   @override
//   void initState() {
//     super.initState();
//     controller.loadDB();
//     itemsDatum = controller.items;
//     controller.getShoppingData().then((data) {
//       setState(() {
//         itemsDatum = data;
//       });
//     });
//   }

//   set visibleOfBottomBar(SetValues values) => setState(() {
//         _visibleOfBottomBar = values.value;
//         _count = countFromDB;
//       });

//   @override
//   Widget build(BuildContext context) {
//     Get.put(HomePageController()).getShoppingData();
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leadingWidth: 80,
//         leading: ElevatedButton.icon(
//           onPressed: () => Navigator.pushNamed(context, '/'),
//           icon: const Icon(Icons.arrow_back_ios),
//           label: const Text(''),
//           style: ElevatedButton.styleFrom(
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             foregroundColor: Colors.black,
//           ),
//         ),
//         title: const Text(
//           'Меню',
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: FutureBuilder<void>(
//         future: controller.getShoppingData(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             print('An error has occurred: ${snapshot.error}');
//             return const Center(child: Text('An error has occurred!'));
//           } else if (snapshot.hasData) {
//             Get.put(HomePageController());
//             return FutureBuilder<bool>(
//                 future: sqlService.isTableNotEmpty(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData && snapshot.data == true) {
//                     return FoodItem(
//                       items: itemsDatum,
//                       callback: (val, count) {
//                         setState(() {
//                           _visibleOfBottomBar = val;
//                           _count = count;
//                         });
//                       },
//                       count: _count,
//                     );
//                   } else {
//                     return FoodItem(
//                       items: itemsDatum,
//                       callback: (val, count) => setState(() {
//                         _visibleOfBottomBar = val;
//                         _count = itemsDatum.length;
//                       }),
//                       count: itemsDatum.length,
//                     );
//                   }
//                 });
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//       bottomNavigationBar: Visibility(
//         visible: _visibleOfBottomBar || itemsDatum.isNotEmpty,
//         child: bottomWidget(count: _count),
//       ),
//     );
//   }
// }
