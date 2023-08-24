import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';

class AllVendorsNearYouCard extends StatelessWidget {
  final Function() onTap;
  final String cardImage,
      vendorName,
      typeOfBusiness,
      rating,
      noOfUsersRated,
      distance;
  const AllVendorsNearYouCard({
    super.key,
    required this.onTap,
    required this.vendorName,
    required this.typeOfBusiness,
    required this.rating,
    required this.noOfUsersRated,
    required this.cardImage,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 355,
        height: 130,
        decoration: ShapeDecoration(
          color: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 24,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/vendors/$cardImage",
                  ),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            kHalfWidthSizedBox,
            Container(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      vendorName,
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.36,
                      ),
                    ),
                  ),
                  kSizedBox,
                  SizedBox(
                    width: 200,
                    child: Text(
                      typeOfBusiness,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  kSizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidStar,
                            color: kStarColor,
                            size: 15,
                          ),
                          SizedBox(
                            width: kDefaultPadding / 10,
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              "$rating ($noOfUsersRated+)",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      kHalfWidthSizedBox,
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidClock,
                            color: kAccentColor,
                            size: 15,
                          ),
                          SizedBox(
                            width: kDefaultPadding / 10,
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              '30 mins',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.28,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}