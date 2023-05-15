import 'package:flutter/material.dart';
import 'package:ne_gorchit/widgets/elements/main_buttons.dart';

class mainButton extends StatelessWidget {
  final Icon buttonIcon;
  final String buttonName;

  const mainButton({
    super.key,
    required this.buttonIcon,
    required this.buttonName,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('button tapped');
      },
      style: ElevatedButton.styleFrom(
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
