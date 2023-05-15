import 'package:flutter/material.dart';
import 'package:ne_gorchit/widgets/elements/main_buttons.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 100,
          horizontal: 10,
        ),
        child: Container(
          color: Colors.white,
          child: const Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: mainButton(
                          buttonIcon: Icon(
                            Icons.menu,
                            size: 50,
                          ),
                          buttonName: 'Меню',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: mainButton(
                          buttonIcon: Icon(
                            Icons.person,
                            size: 50,
                          ),
                          buttonName: 'Официант',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: mainButton(
                          buttonIcon: Icon(
                            Icons.shield,
                            size: 50,
                          ),
                          buttonName: 'Кальян',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: mainButton(
                          buttonIcon: Icon(
                            Icons.check,
                            size: 50,
                          ),
                          buttonName: 'Счет',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: mainButton(
                          buttonIcon: Icon(
                            Icons.reviews,
                            size: 50,
                          ),
                          buttonName: 'Отзыв',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: mainButton(
                          buttonIcon: Icon(
                            Icons.menu,
                            size: 50,
                          ),
                          buttonName: 'Меню',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
