import 'package:flutter/material.dart';

class BillItems extends StatelessWidget {
  const BillItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
        child: const ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        'Бургер',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.end,
                        '850 ₸',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7),
                Text(
                  'котлета из мраморной говядины, маринованный огурчик, сыр Гауда, помидор, салат, фирменный соус',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.none,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
