import 'package:flutter/material.dart';
import 'package:ne_gorchit/resources/resources.dart';

class FoodElement extends StatelessWidget {
  const FoodElement({super.key});

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
      body: ColoredBox(
        color: Colors.white,
        child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return FoodItem();
          },
        ),
      ),
    );
  }
}

class FoodItem extends StatelessWidget {
  const FoodItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.fromRGBO(48, 47, 45, 1),
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.all(
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
              Image(image: AssetImage(AppImages.blinchiki)),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Бургер',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Котлета из мраморной говядины, маринованный огурчик, сыр Гауда, помидорб огурец, салат, фирменный тайский соус',
                      style: TextStyle(
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
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    '850 ₸',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
