import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ne_gorchit/model/menu.dart';

class countButton extends StatefulWidget {
  int counter = 0;

  @override
  State<countButton> createState() => _countButtonState();
}

class _countButtonState extends State<countButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                widget.counter == 0 ? print('counter at 0') : widget.counter--;
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
                backgroundColor: Color.fromRGBO(66, 67, 64, 1)),
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
