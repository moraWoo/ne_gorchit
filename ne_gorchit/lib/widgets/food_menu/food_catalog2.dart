import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ne_gorchit/controller/controller.dart';
import 'package:ne_gorchit/model/menu.dart';
import 'package:ne_gorchit/services/sql_service.dart';
import 'package:ne_gorchit/widgets/food_menu/bottom_bar.dart';
import 'package:ne_gorchit/widgets/food_menu/food_card.dart';

class FoodMenuNew extends StatefulWidget {
  final HomePageController controller = Get.put(HomePageController());

  FoodMenuNew({
    super.key,
  });

  @override
  State<FoodMenuNew> createState() => _FoodMenuNewState();
}

class SetValues {
  final bool value;
  SetValues(this.value);
}

class _FoodMenuNewState extends State<FoodMenuNew> {
  final HomePageController controller = Get.find();
  SQLService sqlService = SQLService();
  int countFromDB = 0;
  List<Datum> itemsDatum = [];

  @override
  void initState() {
    super.initState();
    controller.loadDB();
    itemsDatum = controller.items;
    controller.getShoppingData().then((data) {
      setState(() {
        itemsDatum = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 80,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/'),
          icon: const Icon(Icons.arrow_back_ios),
          label: const Text(''),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
        ),
        title: const Text(
          'Меню',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: controller.getShoppingData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('An error has occurred: ${snapshot.error}');
            return const Center(child: Text('An error has occurred!'));
          } else if (snapshot.hasData) {
            Get.put(HomePageController());
            return FutureBuilder<bool>(
                future: sqlService.isTableNotEmpty(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return ListOfFoodCard(
                      items: itemsDatum,
                    );
                  } else {
                    return ListOfFoodCard(
                      items: itemsDatum,
                    );
                  }
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: controller.showingBottomWidget.value,
          child: bottomWidget(),
        ),
      ),
    );
  }
}
