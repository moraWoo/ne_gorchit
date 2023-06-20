import 'package:ne_gorchit/controller/controller.dart';
import 'package:ne_gorchit/model/menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  var imgUrl = 'http://localhost:4000/';
  final HomePageController controller = Get.put(HomePageController());

  List<Widget> generateCart(BuildContext context, List<Datum> menuList) {
    return menuList
        .map((datum) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border(
                      bottom:
                          BorderSide(color: Colors.grey.shade100, width: 1.0),
                      top: BorderSide(color: Colors.grey.shade100, width: 1.0),
                    )),
                height: 100.0,
                child: Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 5.0)
                          ],
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)),
                          image: DecorationImage(
                              image: NetworkImage(imgUrl + datum.image),
                              fit: BoxFit.fitHeight)),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    datum.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: InkResponse(
                                    onTap: () {
                                      Get.find<HomePageController>()
                                          .removeFromCart(datum.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Блюдо удалено: ${datum.id}'),
                                        ),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text("Цена: ${datum.price.toString()}"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
        .toList();
  }

  getItemTotal(List<Datum> items) {
    double sum = 0.0;
    items.forEach((datum) {
      sum += datum.price;
    });
    return "$sum ₸";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomePageController>();

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 80,
        leading: ElevatedButton.icon(
          onPressed: () => {
            Navigator.pushNamed(context, '/food_catalog2'),
            // controller.eraseCart(),
          },
          icon: const Icon(Icons.arrow_back_ios),
          label: const Text(''),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
        ),
        title: const Text(
          'Корзина',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: GetBuilder<HomePageController>(
                builder: (_) {
                  if (controller.cartItems.length == 0) {
                    return const Center(
                      child: Text("No item found"),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: generateCart(context, controller.cartItems),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: GetBuilder<HomePageController>(
                  builder: (_) {
                    return RichText(
                      text: TextSpan(
                          text: "Всего  ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  getItemTotal(controller.cartItems).toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ]),
                    );
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: 50,
                color: Colors.white,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 100,
                      child: const Text(
                        "Заказать",
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
