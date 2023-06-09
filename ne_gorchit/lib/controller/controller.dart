import 'package:ne_gorchit/services/item_service.dart';
import 'package:ne_gorchit/model/menu.dart';

import 'package:get/get.dart';
import 'package:ne_gorchit/services/sql_service.dart';

class HomePageController extends GetxController {
  ItemServices itemServices = ItemServices();
  List<Datum> items = [];
  List<Datum> cartItems = [];
  List<Datum> cartDataList = [];

  bool isLoading = true;

  SQLService sqlService = SQLService();
  RxBool showingBottomWidget = false.obs;
  RxDouble sumOfCart = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDB();
  }

  Future<void> isAlreadyInCartAll2() async {
    try {
      var showBotWidget = await sqlService.isTableEmpty();
      print('showBotWidget: ${showingBottomWidget.value}');
      print('showBotWidget: ${showBotWidget}');

      showingBottomWidget.value = showBotWidget;
      print('showingBottomWidget.value1: ${showingBottomWidget.value}');
    } catch (e) {
      print(e);
      showingBottomWidget.value = false;
    }
  }

  Future<bool> isAlreadyInCart(int id) async {
    try {
      List<Map<String, dynamic>> cartList = await sqlService.getCartData();
      List<Datum> newData = [];

      for (var item in cartList) {
        newData.add(Datum(
          name: item['name'],
          description: item['description'],
          id: item['id'],
          image: item['image'],
          price: item['price'],
          idTable: item['idTable'],
          fav: item['fav'],
          rating: item['rating'],
          countOfItems: item['countOfItems'],
        ));
      }

      for (var datum in newData) {
        if (datum.id == id) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print(e);

      return false;
    }
  }

  loadDB() async {
    await sqlService.openDB(); // Открываем базу данных
  }

  Future<List<Datum>> getShoppingData() async {
    try {
      List<Map<String, dynamic>> shoppingData =
          await sqlService.getShoppingData();
      List<Datum> newData = [];

      for (var item in shoppingData) {
        newData.add(Datum(
          name: item['name'],
          description: item['description'],
          id: item['id'],
          image: item['image'],
          price: item['price'],
          idTable: item['idTable'],
          fav: item['fav'],
          rating: item['rating'],
          countOfItems: item['countOfItems'],
        ));
      }

      return newData; // Вернуть преобразованный список
    } catch (e) {
      print(e);
      return []; // Вернуть пустой список в случае ошибки
    }
  }

  Future<List<Datum>> getCartData() async {
    try {
      cartDataList = [];
      cartItems = [];
      List<Map<String, dynamic>> cartData = await sqlService.getCartData();

      for (var item in cartData) {
        cartDataList.add(Datum(
          name: item['name'],
          description: item['description'],
          id: item['id'],
          image: item['image'],
          price: item['price'],
          idTable: item['idTable'],
          fav: item['fav'],
          rating: item['rating'],
          countOfItems: item['countOfItems'],
        ));
      }
      print('cartDataList1: $cartDataList');
      print('cartItems: $cartItems');

      return cartDataList; // Вернуть преобразованный список
    } catch (e) {
      print(e);
      return []; // Вернуть пустой список в случае ошибки
    }
  }

  Future addToCart(Datum item) async {
    isLoading = true;
    update();
    var result = await itemServices.addToCart(item);
    isLoading = false;
    update();
    showingBottomWidget.value = true;
    print('item.price: ${item.price}');
    // sumOfCart.value += item.price;
    calculateSumOfCart();

    return result;
  }

  removeFromCart(Datum item, int id) async {
    await itemServices.removeFromCart(item, item.id);

    cartItems.removeWhere((cartItem) => cartItem.id == id);

    bool isNotEmpty =
        await sqlService.isTableEmpty(); // Изменено на isTableEmpty
    print('isNotEmpty: $isNotEmpty');

    showingBottomWidget.value = !isNotEmpty; // Изменено на !isNotEmpty

    // sumOfCart.value -= item.price; // Уменьшение значения sumOfCart
    calculateSumOfCart();

    update();
  }

  void calculateSumOfCart() async {
    List<Datum> cartData = await getCartData();
    double sum = 0;

    for (var item in cartData) {
      double itemTotalPrice = item.price * item.countOfItems;
      sum += itemTotalPrice;
    }

    sumOfCart.value = sum;
  }
}

void main() {
  ItemServices itemServices = ItemServices();
  itemServices.main(); // Вызов main() для заполнения списка items
}
