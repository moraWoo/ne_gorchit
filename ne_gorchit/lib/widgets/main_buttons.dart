import 'package:flutter/material.dart';

class mainButton extends StatelessWidget {
  final Icon buttonIcon;
  final String buttonName;
  final int buttonId;

  const mainButton({
    super.key,
    required this.buttonIcon,
    required this.buttonName,
    required this.buttonId,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('button tapped: $buttonId');
        switch (buttonId) {
          case 1:
            Navigator.popAndPushNamed(context, '/food_catalog');
          case 2:
            Navigator.popAndPushNamed(context, '/food_catalog');
          case 3:
            Navigator.popAndPushNamed(context, '/food_catalog');
          case 4:
            Navigator.popAndPushNamed(context, '/food_catalog');
          case 5:
            Navigator.popAndPushNamed(context, '/food_catalog');
          case 6:
            Navigator.popAndPushNamed(context, '/client_bill');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(66, 67, 64, 1),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buttonIcon,
          const SizedBox(
            height: 15,
          ),
          Text(
            buttonName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
