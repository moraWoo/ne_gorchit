import 'package:flutter/material.dart';
import 'package:ne_gorchit/model/menu.dart';
import 'package:ne_gorchit/resources/resources.dart';
import 'package:http/http.dart' as http;
import 'package:ne_gorchit/services/network_manager.dart';
import 'package:ne_gorchit/widgets/basket.dart';

class FoodMenu extends StatelessWidget {
  const FoodMenu({
    super.key,
  });

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
    );
  }
}

class FoodItem extends StatelessWidget {
  FoodItem({
    super.key,
    required this.items,
  });

  List<Menu> items;
  var imgUrl = 'http://localhost:4000/';
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.fold<int>(0, (count, menu) => count + menu.data.length),
      itemBuilder: (context, index) {
        var menuIndex = 0;
        var dataIndex = index;
        for (var menu in items) {
          if (dataIndex < menu.data.length) {
            break;
          }
          dataIndex -= menu.data.length;
          menuIndex++;
        }
        var item = items[menuIndex].data[dataIndex];
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
                  buttonWithPrice(item: item),
                  // countButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class buttonWithPrice extends StatelessWidget {
  const buttonWithPrice({
    super.key,
    required this.item,
  });

  final Datum item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: ElevatedButton(
        onPressed: () {
          countButton();
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
    );
  }
}
