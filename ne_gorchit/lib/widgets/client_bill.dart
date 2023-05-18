import 'package:flutter/material.dart';

class ClientBill extends StatelessWidget {
  const ClientBill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(70.0),
            child: Text(
              'Мой счет',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
