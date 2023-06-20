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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];
        var resultUrl = imgUrl;
        return CardItemWidget(
          item: item,
          imgUrl: resultUrl,
          onPressedMinus: () {
            print('onPressedMinus');
            controller.removeFromCart(item.id);
            // Обработчик нажатия на кнопку "-"
            // Здесь можно выполнить соответствующие действия
          },
          onPressedPlus: () {
            print('onPressedPlus');
            controller.addToCart(item);
            // Обработчик нажатия на кнопку "+"
            // Здесь можно выполнить соответствующие действия
          },
        );
      },
    );
  }
}

// class CardItemWidget extends StatelessWidget {
//   final Datum item;
//   final String imgUrl;
//   final Function onPressedMinus;
//   final Function onPressedPlus;

//   CardItemWidget({
//     required this.item,
//     required this.imgUrl,
//     required this.onPressedMinus,
//     required this.onPressedPlus,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var resultUrl = imgUrl + item.image;
//     return Padding(
//       padding: EdgeInsets.all(20.0),
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           color: Color.fromRGBO(48, 47, 45, 1),
//           border: Border.all(
//             color: Colors.black.withOpacity(0.2),
//           ),
//           borderRadius: const BorderRadius.all(
//             Radius.circular(20),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 8,
//               offset: Offset(0, 10),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           clipBehavior: Clip.hardEdge,
//           child: Column(
//             children: [
//               Image.network(resultUrl),
//               nameAndDescriptionFoodItem(item: item),
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: ElevatedButton(
//                   onPressed: () => onPressedMinus(),
//                   child: Text(
//                     item.price.toString(),
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     minimumSize: Size(190, 60),
//                     backgroundColor: Color.fromRGBO(66, 67, 64, 1),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class CardItemWidget extends StatefulWidget {
  final Datum item;
  final String imgUrl;
  final Function onPressedMinus;
  final Function onPressedPlus;

  CardItemWidget({
    required this.item,
    required this.imgUrl,
    required this.onPressedMinus,
    required this.onPressedPlus,
    Key? key,
  }) : super(key: key);

  @override
  _CardItemWidgetState createState() => _CardItemWidgetState();
}

class _CardItemWidgetState extends State<CardItemWidget> {
  bool showButtons = false;
  int counter = 0;

  @override
  Widget build(BuildContext context) {
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
              if (showButtons)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (counter > 0) {
                              counter--;
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
                        // counter.toString(),
                        (widget.item.price * counter).toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 70),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            counter++;
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
              if (!showButtons)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showButtons = true;
                        counter = 1;
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
