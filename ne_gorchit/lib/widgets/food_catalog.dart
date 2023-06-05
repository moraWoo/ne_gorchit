import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ne_gorchit/controller/cart_controller.dart';
import 'package:ne_gorchit/model/cart.dart';
import 'package:ne_gorchit/model/menu.dart';
import 'package:ne_gorchit/resources/resources.dart';
import 'package:http/http.dart' as http;
import 'package:ne_gorchit/services/network_manager.dart';
import 'package:ne_gorchit/widgets/cart.dart';
import 'package:ne_gorchit/widgets/bottom_bar.dart';
import 'package:ne_gorchit/widgets/name_description.dart';

class FoodMenu extends StatefulWidget {
  FoodMenu({
    super.key,
  });

  @override
  State<FoodMenu> createState() => _FoodMenuState();
}

class SetValues {
  final bool value;
  final int count;

  SetValues(this.value, this.count);
}

class _FoodMenuState extends State<FoodMenu> {
  bool _visibleOfBottomBar = false;
  int _count = 0;
  // final HomePageController controller = Get.put(HomePageController());

  set visibleOfBottomBar(SetValues values) => setState(() {
        _visibleOfBottomBar = values.value;
        _count = values.count;
      });

  @override
  int tabIndex = 0;

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
      body: FutureBuilder<List<Menu>>(
        future: fetchItems(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(context);
            print(snapshot);

            return const Center(child: Text('An error has occurred!'));
          } else if (snapshot.hasData) {
            // Get.put(HomePageController());
            print('+++');

            // print(controller.cartItems);
            return FoodItem(
                items: snapshot.data!,
                callback: (val, count) => setState(
                      () => {_visibleOfBottomBar = val, _count = count},
                    ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: Visibility(
        visible: _visibleOfBottomBar,
        child: bottomWidget(count: _count),
      ),
    );
  }
}

typedef void BottomVisibleCallBack(bool val, int count);

class FoodItem extends StatefulWidget {
  final BottomVisibleCallBack callback;

  FoodItem({
    super.key,
    required this.items,
    required this.callback,
  });

  List<Menu> items;

  @override
  State<FoodItem> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  var imgUrl = 'http://localhost:4000/';
  bool _isButtonWithPriceDisabled = false;
  bool isPressedButton = false;
  List<int> counters = [];
  List<bool> _isButtonWithPriceDisabledList = [];
  int sumOfElements = 0;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    // Инициализируем счетчики и флаги для каждого элемента
    counters = List<int>.filled(widget.items[0].data.length, 0);
    _isButtonWithPriceDisabledList =
        List<bool>.filled(widget.items[0].data.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount:
          widget.items.fold<int>(0, (count, menu) => count + menu.data.length),
      itemBuilder: (context, index) {
        var menuIndex = 0;
        var dataIndex = index;
        for (var menu in widget.items) {
          if (dataIndex < menu.data.length) {
            break;
          }
          dataIndex -= menu.data.length;
          menuIndex++;
        }
        var item = widget.items[menuIndex].data[dataIndex];
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
                  (!_isButtonWithPriceDisabledList[index])
                      ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            onPressed: () {
                              //=============================================================
                              if (counters[index] == 0) {
                                counters[index]++;
                              }
                              sumOfElements = counters
                                  .reduce((value, element) => value + element);
                              widget.callback(
                                _isButtonWithPriceDisabledList[index] =
                                    !_isButtonWithPriceDisabledList[index],
                                _count = sumOfElements,
                              );
                            },
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
                                backgroundColor: Color.fromRGBO(66, 67, 64, 1)),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  sumOfElements = counters.reduce(
                                      (value, element) => value + element);
                                  print('counters: $counters');

                                  setState(() {
                                    counters[index]--;
                                    sumOfElements = counters.reduce(
                                        (value, element) => value + element);
                                    widget.callback(
                                        _isButtonWithPriceDisabledList[index] =
                                            _isButtonWithPriceDisabledList[
                                                index],
                                        _count = sumOfElements);
                                  });

                                  if (sumOfElements == 0) {
                                    print('sumOfElements == 0');

                                    setState(() {
                                      widget.callback(
                                          _isButtonWithPriceDisabledList[
                                                  index] =
                                              !_isButtonWithPriceDisabledList[
                                                  index],
                                          _count = sumOfElements);
                                    });
                                  } else if (counters[index] == 0) {
                                    print('counters[index] == 0');

                                    setState(() {
                                      sumOfElements = counters.reduce(
                                          (value, element) => value + element);
                                      widget.callback(
                                          _isButtonWithPriceDisabledList[
                                                  index] =
                                              _isButtonWithPriceDisabledList[
                                                  index],
                                          _count = sumOfElements);
                                      _isButtonWithPriceDisabledList[index] =
                                          !_isButtonWithPriceDisabledList[
                                              index];
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    minimumSize: Size(60, 60),
                                    backgroundColor:
                                        Color.fromRGBO(66, 67, 64, 1)),
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${counters[index]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '${item.price * counters[index]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    counters[index]++;
                                    sumOfElements = counters.reduce(
                                        (value, element) => value + element);
                                    widget.callback(
                                      _isButtonWithPriceDisabledList[index] =
                                          _isButtonWithPriceDisabledList[index],
                                      _count = sumOfElements,
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    minimumSize: Size(60, 60),
                                    backgroundColor:
                                        Color.fromRGBO(66, 67, 64, 1)),
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
      },
    );
  }
}
