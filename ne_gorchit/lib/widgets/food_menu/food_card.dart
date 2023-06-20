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

class FoodCard extends StatefulWidget {
  List<Datum> items = [];
  final BottomVisibleCallBack callback;
  final int count;

  FoodCard({
    required this.items,
    required this.callback,
    required this.count,
    Key? key,
  }) : super(key: key);

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  var imgUrl = 'http://localhost:4000/';
  bool _isButtonWithPriceDisabled = false;
  bool isPressedButton = false;
  List<int> counters = [];
  List<bool> _isButtonWithPriceDisabledList = [];
  int sumOfElements = 0;
  int _count = 0;
  final HomePageController controller = Get.put(HomePageController());
  List<Datum> cartItems = [];
  SQLService sqlService = SQLService();

  @override
  void initState() {
    super.initState();

    sqlService = SQLService();
    counters = List<int>.filled(widget.items.length, 0);
    _isButtonWithPriceDisabledList =
        List<bool>.filled(widget.items.length, false);
    counters = List<int>.filled(widget.items.length, 0);

    sqlService.getCartList().then((list) {
      setState(() {
        cartItems = list;
        _count = cartItems.length;
        for (var item in cartItems) {
          counters[widget.items.indexWhere((datum) => datum.id == item.id)]++;
          _isButtonWithPriceDisabledList[
              widget.items.indexWhere((datum) => datum.id == item.id)] = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        var item = widget.items[index];
        var resultUrl = imgUrl + item.image;
        return CardItemWidget(
          item: item,
          imgUrl: resultUrl,
          isButtonWithPriceDisabled: _isButtonWithPriceDisabledList[index],
          counter: counters[index],
          onPressedMinus: () {
            print('onPressedMinus');
            // Обработчик нажатия на кнопку "-"
            // Здесь можно выполнить соответствующие действия
          },
          onPressedPlus: () {
            print('onPressedPlus');
            // Обработчик нажатия на кнопку "+"
            // Здесь можно выполнить соответствующие действия
          },
        );
      },
    );
  }
}

class CardItemWidget extends StatelessWidget {
  final Datum item;
  final String imgUrl;
  final bool isButtonWithPriceDisabled;
  final int counter;
  final Function onPressedMinus;
  final Function onPressedPlus;

  CardItemWidget({
    required this.item,
    required this.imgUrl,
    required this.isButtonWithPriceDisabled,
    required this.counter,
    required this.onPressedMinus,
    required this.onPressedPlus,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var resultUrl = imgUrl + item.image;
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
              Image.network(
                resultUrl,
              ),
              nameAndDescriptionFoodItem(item: item),
              (!isButtonWithPriceDisabled)
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: onPressedMinus(),
                        child: Text(
                          item.price.toString(),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          minimumSize: Size(190, 60),
                          backgroundColor: Color.fromRGBO(66, 67, 64, 1),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            onPressed: onPressedMinus(),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              minimumSize: Size(60, 60),
                              backgroundColor: Color.fromRGBO(66, 67, 64, 1),
                            ),
                            child: Text(
                              '-',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '$counter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '${item.price * counter}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            onPressed: onPressedPlus(),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              minimumSize: Size(60, 60),
                              backgroundColor: Color.fromRGBO(66, 67, 64, 1),
                            ),
                            child: Text(
                              '+',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
