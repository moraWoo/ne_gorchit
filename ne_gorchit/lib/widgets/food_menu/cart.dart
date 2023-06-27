import 'package:ne_gorchit/controller/controller.dart';
import 'package:ne_gorchit/model/menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ne_gorchit/services/sql_service.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var imgUrl = 'http://localhost:4000/';
  final HomePageController controller = Get.put(HomePageController());
  SQLService sqlService = SQLService();
  List<Datum> itemsDatum = [];

  getItemTotal(List<Datum> items) {
    double sum = 0.0;
    items.forEach((datum) {
      sum += datum.price;
    });
    return "$sum ₸";
  }

  @override
  void initState() {
    controller.loadDB();
    itemsDatum = controller.items;
    controller.getCartData().then((data) {
      setState(() {
        itemsDatum = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 80,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/food_catalog2'),
          icon: const Icon(Icons.arrow_back_ios),
          label: const Text(''),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
        ),
        title: const Text(
          'Заказ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: controller.loadDB(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('An error has occurred: ${snapshot.error}');
            return const Center(child: Text('An error has occurred!'));
          } else if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder<List<Datum>>(
              future: controller.getCartData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('An error has occurred: ${snapshot.error}');
                  return const Center(child: Text('An error has occurred!'));
                } else if (snapshot.hasData) {
                  return ListOfItemsInCart(items: snapshot.data!);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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
                              text: '${controller.sumOfCart.value}',
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

class ListOfItemsInCart extends StatelessWidget {
  final List<Datum> items;
  var imgUrl = 'http://localhost:4000/';
  final HomePageController controller = Get.put(HomePageController());

  ListOfItemsInCart({
    required this.items,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];
        var resultUrl = imgUrl;
        return CartItemWidget(
          item: item,
          imgUrl: resultUrl,
        );
      },
    );
  }
}

class CartItemWidget extends StatefulWidget {
  final Datum item;
  final String imgUrl;

  CartItemWidget({
    required this.item,
    required this.imgUrl,
    Key? key,
  }) : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    var resultUrl = widget.imgUrl + widget.item.image;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(48, 47, 45, 1),
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Image.network(
                resultUrl,
                width: 150,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      'Количество: ${widget.item.countOfItems}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_circle_outline_sharp,
                          color: Colors.red,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.remove_circle_outline_sharp,
                          color: Colors.red,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
