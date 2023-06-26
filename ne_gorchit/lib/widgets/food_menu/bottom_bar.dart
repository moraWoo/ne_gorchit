import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ne_gorchit/controller/controller.dart';
import 'package:ne_gorchit/model/menu.dart';

class bottomWidget extends StatefulWidget {
  final int count;

  const bottomWidget({
    Key? key,
    required this.count,
  }) : super(key: key);

  @override
  State<bottomWidget> createState() => _bottomWidgetState();
}

class _bottomWidgetState extends State<bottomWidget> {
  final HomePageController controller = Get.put(HomePageController());

  String getItemTotal(List<Datum> items) {
    List<Datum> cartItems = controller.cartItems;
    double sum = 0.0;
    cartItems.forEach((datum) {
      sum += datum.price;
    });
    return "$sum ₸";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: Colors.white,
      child: InkWell(
        onTap: () => print('tap on close'),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(48, 47, 45, 1),
                spreadRadius: 0,
                blurRadius: 0.1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                  minimumSize: MaterialStateProperty.all(
                    Size(80, 50),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/cart');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '25-35 мин',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'Заказ',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Obx(() => Text(
                          '${controller.sumOfCart()}',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ))
                    // Text(
                    //   '0.0',
                    //   style: TextStyle(color: Colors.black),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
