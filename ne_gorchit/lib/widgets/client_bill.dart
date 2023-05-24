import 'package:flutter/material.dart';
import 'package:ne_gorchit/widgets/elements/bill_items.dart';
import 'package:ne_gorchit/widgets/elements/result_items.dart';

class ClientBill extends StatefulWidget {
  const ClientBill({super.key});

  @override
  State<ClientBill> createState() => _ClientBillState();
}

class _ClientBillState extends State<ClientBill> {
  int buildingCount = 6;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 80,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/'),
          icon: const Icon(Icons.arrow_back_ios),
          label: const Text(
            '',
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
        ),
        title: const Text(
          'Мой счет',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ColoredBox(
        color: Colors.white,
        child: ListView.builder(
          itemCount: buildingCount,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            if (index == buildingCount - 1) {
              return Container(
                child: Center(
                  child: ResultOfItems(),
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: BillItems(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
