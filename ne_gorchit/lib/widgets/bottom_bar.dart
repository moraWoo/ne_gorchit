import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ne_gorchit/controller/cart_controller.dart';
import 'package:ne_gorchit/model/menu.dart';

class bottomWidget extends StatefulWidget {
  final int count;

  const bottomWidget({
    super.key,
    required this.count,
  });

  @override
  State<bottomWidget> createState() => _bottomWidgetState();
}

List<Datum> items = [];

class _bottomWidgetState extends State<bottomWidget> {
  final HomePageController controller = Get.put(HomePageController());
  getItemTotal(List<Datum> items) {
    items = controller.cartItems;
    double sum = 0.0;
    items.forEach((datum) {
      sum += datum.price;
    });
    print('iii: $items');
    return "$sum ₸";
  }

  @override
  Widget build(BuildContext context) {
    getItemTotal(items);

    return Container(
      height: 120,
      color: Colors.white,
      child: InkWell(
        onTap: () => print('tap on close'),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(48, 47, 45, 1),
                  spreadRadius: 0,
                  blurRadius: 0.1),
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
                    backgroundColor: MaterialStatePropertyAll(Colors.yellow),
                    minimumSize: MaterialStatePropertyAll(
                      Size(80, 50),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
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
                      Text(
                        widget.count.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Text(
                        getItemTotal(items),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
