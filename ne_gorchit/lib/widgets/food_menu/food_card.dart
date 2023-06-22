import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ne_gorchit/controller/controller.dart';
import 'package:ne_gorchit/model/menu.dart';
import 'package:http/http.dart' as http;
import 'package:ne_gorchit/services/network_manager.dart';
import 'package:ne_gorchit/services/sql_service.dart';
import 'package:ne_gorchit/widgets/food_menu/bottom_bar.dart';
import 'package:ne_gorchit/widgets/name_description.dart';

typedef void BottomVisibleCallBack(bool val, int count);

class ListOfFoodCard extends StatelessWidget {
  final List<Datum> items;
  final BottomVisibleCallBack callback;
  final int count;
  var imgUrl = 'http://localhost:4000/';
  final HomePageController controller = Get.put(HomePageController());

  ListOfFoodCard({
    required this.items,
    required this.callback,
    required this.count,
    Key? key,
  }) : super(key: key);

  Future<bool> getShowButtons(Datum item) async {
    return await controller.isAlreadyInCart(item.id);
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];
        var resultUrl = imgUrl;
        print(
            'items $index: ${items[index].name} ${items[index].countOfItems}');
        return FutureBuilder<bool>(
          future: controller.isAlreadyInCart(item.id),
          builder: (context, snapshot) {
            bool showButtons = snapshot.data ?? false;

            return CardItemWidget(
              item: item,
              imgUrl: resultUrl,
              onPressedMinus: () {
                print('onPressedMinus');
                // controller.removeFromCart(item.id);
              },
              onPressedPlus: () {
                print('onPressedPlus');
                // controller.addToCart(item);
              },
              showButtons: showButtons,
            );
          },
        );
      },
    );
  }
}

class CardItemWidget extends StatefulWidget {
  final Datum item;
  final String imgUrl;
  final Function onPressedMinus;
  final Function onPressedPlus;
  bool showButtons;

  CardItemWidget({
    required this.item,
    required this.showButtons,
    required this.imgUrl,
    required this.onPressedMinus,
    required this.onPressedPlus,
    Key? key,
  }) : super(key: key);

  @override
  _CardItemWidgetState createState() => _CardItemWidgetState();
}

class _CardItemWidgetState extends State<CardItemWidget> {
  int counter = 0;
  final HomePageController controller = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
    print('items: ${widget.item.name}');
  }

  @override
  Widget build(BuildContext context) {
    print('showButtons1: ${widget.showButtons}');

    var resultUrl = widget.imgUrl + widget.item.image;
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.fromRGBO(48, 47, 45, 1),
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
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              Image.network(resultUrl),
              nameAndDescriptionFoodItem(item: widget.item),
              if (widget.showButtons)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (widget.item.countOfItems > 0) {
                              widget.item.countOfItems--;
                              controller.removeFromCart(
                                  widget.item, widget.item.id);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            minimumSize: Size(60, 60),
                            backgroundColor: Color.fromRGBO(66, 67, 64, 1)),
                        child: Text(
                          '-',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 70),
                      Text(
                        (widget.item.price * widget.item.countOfItems)
                            .toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 70),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.item.countOfItems += 1;
                            controller.addToCart(widget.item);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            minimumSize: Size(60, 60),
                            backgroundColor: Color.fromRGBO(66, 67, 64, 1)),
                        child: Text(
                          '+',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (!widget.showButtons)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // widget.showButtons = true;
                        widget.item.countOfItems = 1;
                        controller.addToCart(widget.item);
                      });
                    },
                    child: Text(
                      widget.item.price.toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minimumSize: Size(190, 60),
                      backgroundColor: Color.fromRGBO(66, 67, 64, 1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
