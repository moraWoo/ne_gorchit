import 'package:flutter/material.dart';
import 'package:ne_gorchit/model/menu.dart';
import 'package:ne_gorchit/resources/resources.dart';
import 'package:http/http.dart' as http;
import 'package:ne_gorchit/services/network_manager.dart';
import 'package:ne_gorchit/widgets/basket.dart';

class FoodMenu extends StatefulWidget {
  FoodMenu({
    super.key,
  });

  @override
  State<FoodMenu> createState() => _FoodMenuState();
}

class _FoodMenuState extends State<FoodMenu> {
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
          print('from FutureBuilder: $snapshot.error');
          if (snapshot.hasError) {
            return const Center(child: Text('An error has occurred!'));
          } else if (snapshot.hasData) {
            print('========');
            print(snapshot);
            return FoodItem(
              items: snapshot.data!,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: Visibility(
        visible: true,
        child: bottomWidget(),
      ),
    );
  }
}

class bottomWidget extends StatelessWidget {
  const bottomWidget({
    super.key,
  });

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
                  onPressed: () {},
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
                        '3005 ₸',
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

class FoodItem extends StatefulWidget {
  int counter = 1;

  FoodItem({
    super.key,
    required this.items,
  });

  List<Menu> items;

  @override
  State<FoodItem> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  var imgUrl = 'http://localhost:4000/';
  bool _isButtonDisabled = false;
  bool onClicked = false;
  int counter = 1;

  void hideButton() {
    setState(() {
      _isButtonDisabled = !_isButtonDisabled;
    });
  }

  @override
  void initState() {
    super.initState();
    onClicked = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool bottomVisible = true;
    bool secondOnClicked;
    if (onClicked) {
      bottomVisible = true;
    } else {
      bottomVisible = false;
    }

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
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.grey,
                            decoration: TextDecoration.none,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 7),
                        Text(
                          item.description,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              decoration: TextDecoration.none),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  (!_isButtonDisabled)
                      ? Padding(
                          padding: EdgeInsets.all(15.0),
                          child: ElevatedButton(
                            onPressed: () {
                              hideButton();
                              print(_isButtonDisabled);
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
                                  if (widget.counter == 1) {
                                    hideButton();
                                  } else {
                                    setState(() {
                                      widget.counter--;
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
                              '${widget.counter}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    print('set');
                                    widget.counter++;
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
