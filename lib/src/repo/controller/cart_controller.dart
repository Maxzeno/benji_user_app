// ignore_for_file: empty_catches, invalid_use_of_protected_member

import 'package:benji/src/repo/controller/error_controller.dart';
import 'package:benji/src/repo/models/cart_model/cart_model.dart';
import 'package:benji/src/repo/models/product/product.dart';
import 'package:benji/src/repo/utils/user_cart.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance {
    return Get.find<CartController>();
  }

  var subTotal = <double>[].obs;
  var countCartAll = 0.obs;
  var countCartVendor = <int>[].obs;
  var isLoad = false.obs;
  var cartProducts = <List<Product>>[].obs;
  var formatOfOrder = <Map<String, dynamic>>[].obs;

  Future clearCartProduct(int index) async {
    clearCart(index);
    // removeAtIndexFast(index);
    update();
  }

  void cartTotalNumberForAll() {
    countCartAll.value = cartTotalNumber();
    update();
  }

  void incrementQuantityForCartPage(Product product, int index) async {
    await addToCart(product);
    // subTotal.value[index] += product.price;
    // update();
    await getCartProduct();
    cartTotalNumberForAll();
  }

  void decrementQuantityForCartPage(Product product, int index) async {
    await minusFromCart(product);
    // subTotal.value[index] -= product.price;
    // update();
    await getCartProduct();
    cartTotalNumberForAll();
  }

  Future getCartProduct() async {
    List<VendorInfo> allCart = getAllCartItem();
    isLoad.value = true;
    // update();

    List<double> totalList = [];
    List<List<Product>> productsList = [];
    List<int> countCartV = [];
    for (var i = 0; i < allCart.length; i++) {
      double total = 0.0;
      List<Product> products = [];
      countCartV.add(allCart[i].vendorData.length);
      for (var j = 0; j < allCart[i].vendorData.length; j++) {
        try {
          Product product =
              await getProductById(allCart[i].vendorData[j].productId);
          products.add(product);
          total += (product.price * allCart[i].vendorData[j].quantity);
        } catch (e) {
          allCart[i].vendorData.removeAt(j);
          ApiProcessorController.errorSnack(
              'Failed to load ${allCart[i].vendorData[j].productId}');
        }
      }
      totalList.add(total);
      productsList.add(products);
    }
    isLoad.value = false;
    subTotal.value = totalList;
    cartProducts.value = productsList;
    countCartVendor.value = countCartV;

    formatOfOrder.value = [];
    for (var cart in allCart) {
      formatOfOrder.value.add(cart.toJson());
    }
    update();
  }
}
