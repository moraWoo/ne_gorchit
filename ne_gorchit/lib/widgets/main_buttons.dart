import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

class mainButton extends StatefulWidget {
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
  State<mainButton> createState() => _mainButtonState();
}

class _mainButtonState extends State<mainButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;
  AnimationStatus _completed = AnimationStatus.completed;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _status = status;
        _completed = status;
        if (status == AnimationStatus.completed) {
          sleep(Duration(milliseconds: 1000));
          _controller.reverse();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        switch (widget.buttonId) {
          case 1:
            Navigator.popAndPushNamed(context, '/food_catalog');
          case 2:
            Navigator.popAndPushNamed(context, '/food_catalog2');

          case 3:
            if (_status == AnimationStatus.dismissed) {
              _controller.forward();
            }
          case 4:
            if (_status == AnimationStatus.dismissed) {
              _controller.forward();
            }
          case 5:
          case 6:
            Navigator.popAndPushNamed(context, '/client_bill');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _animation.value <= 0.5
            ? Color.fromRGBO(66, 67, 64, 1)
            : Color.fromRGBO(8, 167, 45, 1),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0015)
          ..rotateY(pi * _animation.value),
        child: _animation.value <= 0.2
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.buttonIcon,
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.buttonName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Transform(
                    alignment: FractionalOffset.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0015)
                      ..rotateY(pi * _animation.value),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
