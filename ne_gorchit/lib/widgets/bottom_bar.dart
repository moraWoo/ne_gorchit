import 'package:flutter/material.dart';

class bottomWidget extends StatefulWidget {
  final int count;

  const bottomWidget({
    super.key,
    required this.count,
  });

  @override
  State<bottomWidget> createState() => _bottomWidgetState();
}

class _bottomWidgetState extends State<bottomWidget> {
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
                        widget.count.toString(),
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
