import 'package:benji/src/components/image/my_image.dart';
import 'package:benji/src/repo/models/product/product.dart';
import 'package:benji/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../providers/constants.dart';

class ProductCard extends StatelessWidget {
  final Function()? onTap;
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

//===================== Number format ==========================\\
  String formattedText(double value) {
    final numberFormat = NumberFormat('#,##0');
    return numberFormat.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: ShapeDecoration(
          color: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19616161),
              blurRadius: 5,
              // offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 186,
              decoration: ShapeDecoration(
                color: kPageSkeletonColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7.20),
                    topRight: Radius.circular(7.20),
                  ),
                ),
              ),
              child: Center(
                  child: MyImage(
                url: product.productImage,
                radiusBottom: 0,
                radiusTop: 7.5,
              )),
            ),
            kSizedBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: kTextBlackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // kHalfSizedBox,
                  SizedBox(
                    child: Text(
                      product.vendorId.shopName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kGreyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.43,
                      ),
                    ),
                  ),
                  // kHalfSizedBox,
                  SizedBox(
                    child: Text(
                      product.subCategoryId.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kAccentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.43,
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  SizedBox(
                    child: Text(
                      '₦${formattedText(product.price)}',
                      style: const TextStyle(
                        color: kTextBlackColor,
                        fontSize: 20,
                        fontFamily: 'Sen',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  kHalfSizedBox
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
