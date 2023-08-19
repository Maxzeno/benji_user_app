import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';
import '../my_floating_snackbar.dart';

class VendorFoodContainer extends StatefulWidget {
  final Function() onTap;
  const VendorFoodContainer({
    super.key,
    required this.onTap,
  });

  @override
  State<VendorFoodContainer> createState() => _VendorFoodContainerState();
}

class _VendorFoodContainerState extends State<VendorFoodContainer> {
  //======================================= ALL VARIABLES ==========================================\\
  int _quantity = 1;
  double _productPrice = 12000;

  //======================================= BOOL VALUES ==========================================\\
  bool isAddedToCart = false;

  //======================================= FUNCTIONS ==========================================\\

  void incrementQuantity() {
    setState(() {
      _quantity++; // Increment the quantity by 1
    });
  }

  void decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--; // Decrement the quantity by 1, but ensure it doesn't go below 1
      } else {
        cartFunction();
      }
    });
  }

  void cartFunction() {
    setState(() {
      isAddedToCart = !isAddedToCart;
    });

    mySnackBar(
      context,
      "Success!",
      isAddedToCart ? "Item has been added to cart." : "Item has been removed.",
      Duration(
        seconds: 1,
      ),
    );
  }

//===================== Number format ==========================\\
  String formattedText(double value) {
    final numberFormat = NumberFormat('#,##0');
    return numberFormat.format(value);
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    // double mediaHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2.5),
        width: MediaQuery.of(context).size.width,
        decoration: ShapeDecoration(
          color: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: [
            BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 24,
                offset: Offset(0, 4),
                spreadRadius: 0)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 92,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/food/pasta.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            kHalfWidthSizedBox,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: mediaWidth / 2,
                  child: Text(
                    'Smokey Jollof Pasta',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                kHalfSizedBox,
                Container(
                  width: mediaWidth / 2,
                  child: Text(
                    'Short description about the food here',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF676565),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                kHalfSizedBox,
                Row(
                  children: [
                    SizedBox(
                      width: mediaWidth / 4,
                      child: Text(
                        "₦${formattedText(_productPrice)}",
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                          fontFamily: 'Sen',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: mediaWidth / 4,
                      height: 17,
                      child: Text(
                        "Qty: 200",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: kTextGreyColor,
                          fontSize: 13.60,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            isAddedToCart
                ? Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          decrementQuantity();
                        },
                        icon: Icon(
                          Icons.remove_circle,
                          color: kAccentColor,
                          size: 30,
                        ),
                      ),
                      Text(
                        "$_quantity",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          incrementQuantity();
                        },
                        icon: Icon(
                          Icons.add_circle_rounded,
                          color: kAccentColor,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                : IconButton(
                    onPressed: () {
                      cartFunction();
                    },
                    icon: Icon(
                      Icons.add_circle_rounded,
                      color: kAccentColor,
                      size: 30,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
