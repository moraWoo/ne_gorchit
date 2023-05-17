import 'package:flutter/material.dart';
import 'package:ne_gorchit/widgets/elements/food_catalog.dart';
import 'package:ne_gorchit/widgets/elements/main_buttons.dart';

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
            Navigator.popAndPushNamed(context, '/widgets');
          case 2:
            Navigator.popAndPushNamed(context, '/widgets');
          case 3:
            Navigator.popAndPushNamed(context, '/widgets');
          case 4:
            Navigator.popAndPushNamed(context, '/widgets');
          case 5:
            Navigator.popAndPushNamed(context, '/widgets');
          case 6:
            Navigator.popAndPushNamed(context, '/widgets');
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
          SizedBox(
            height: 15,
          ),
          Text(
            buttonName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
