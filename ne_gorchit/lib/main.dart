import 'package:flutter/material.dart';
import 'package:ne_gorchit/theme/app_colors.dart';
import 'package:ne_gorchit/widgets/client_bill.dart';
import 'package:ne_gorchit/widgets/food_catalog.dart';
import 'package:ne_gorchit/widgets/main_menu.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainDarkBlue,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      routes: {
        '/': (context) => MainMenu(),
        '/food_catalog': (context) => FoodMenu(),
        '/client_bill': (context) => ClientBill(),
        // '/mainScreen': (context) => MainScreenWidget(),
        // '/mainScreen/movie_details': (context) {
        //   final arguments = ModalRoute.of(context)?.settings.arguments as int;
        //   if (arguments is int) {
        //     return MovieDetailsWidget(movieId: arguments);
        //   } else {
        //     return MovieDetailsWidget(movieId: 0);
        //   }
        // },
      },
      // initialRoute: '/main_menu',
      initialRoute: '/',
    );
  }
}
