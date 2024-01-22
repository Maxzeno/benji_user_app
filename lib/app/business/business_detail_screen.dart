// ignore_for_file: unused_field, use_build_context_synchronously

import 'package:benji/app/business/about_business.dart';
import 'package:benji/app/business/business_products.dart';
import 'package:benji/src/components/image/my_image.dart';
import 'package:benji/src/repo/controller/error_controller.dart';
import 'package:benji/src/repo/models/vendor/vendor.dart';
import 'package:benji/src/repo/utils/favorite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/section/rate_vendor_dialog.dart';
import '../../src/components/snackbar/my_floating_snackbar.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/my_liquid_refresh.dart';
import '../../src/providers/responsive_constant.dart';
import '../../theme/colors.dart';
import 'business_location.dart';
import 'report_business.dart';

class BusinessDetailScreen extends StatefulWidget {
  final BusinessModel vendor;
  const BusinessDetailScreen({
    super.key,
    required this.vendor,
  });

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen>
    with SingleTickerProviderStateMixin {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    _tabBarController = TabController(length: 2, vsync: this);
    getFavoriteVSingle(widget.vendor.id.toString()).then(
      (value) {
        setState(() {
          _isAddedToFavorites = value;
        });
      },
    );
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    scrollController.dispose();
    scrollController.removeListener(() {});
    super.dispose();
  }

  //========================= VARIABLES =========================\\
  bool refreshing = false;

  Future<void> _handleRefresh() async {
    setState(() {
      refreshing = true;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      refreshing = false;
    });
  }

  _toBusinessLocation() {
    double latitude;
    double longitude;
    if (kIsWeb) {
      ApiProcessorController.errorSnack("Not supported on web");
      return;
    }
    try {
      latitude = double.parse(widget.vendor.latitude);
      longitude = double.parse(widget.vendor.longitude);
      if (latitude >= -90 &&
          latitude <= 90 &&
          longitude >= -180 &&
          longitude <= 180) {
      } else {
        ApiProcessorController.errorSnack("Couldn't get the address");
        return;
      }
    } catch (e) {
      ApiProcessorController.errorSnack("Couldn't get the address");
      return;
    }
    Get.to(
      () => BusinessLocation(vendor: widget.vendor),
      routeName: 'BusinessLocation',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

//==========================================================================================\\

  //=================================== ALL VARIABLES ====================================\\
  int selectedRating = 0;

  //=================================== CONTROLLERS ====================================\\
  late TabController _tabBarController;
  final ScrollController scrollController = ScrollController();

//===================== KEYS =======================\\
  // final _formKey = GlobalKey<FormState>();

//===================== FOCUS NODES =======================\\
  FocusNode rateVendorFN = FocusNode();

//===================== BOOL VALUES =======================\\
  bool isScrollToTopBtnVisible = false;
  bool _isAddedToFavorites = false;

//================================================= FUNCTIONS ===================================================\\

  Future<void> scrollToTop() async {
    await scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      isScrollToTopBtnVisible = false;
    });
  }

  Future<void> scrollListener() async {
    if (scrollController.position.pixels >= 200 &&
        isScrollToTopBtnVisible != true) {
      setState(() {
        isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 200 &&
        isScrollToTopBtnVisible == true) {
      setState(() {
        isScrollToTopBtnVisible = false;
      });
    }
  }

  void _addToFavorites() async {
    bool val = await favoriteItV(widget.vendor.id.toString());
    setState(() {
      _isAddedToFavorites = val;
    });

    mySnackBar(
      context,
      kSuccessColor,
      "Success",
      _isAddedToFavorites
          ? "Vendor has been added to favorites"
          : "Vendor been removed from favorites",
      const Duration(milliseconds: 500),
    );
  }

  int _selectedtabbar = 0;
  void _clickOnTabBarOption(value) async {
    setState(() {
      _selectedtabbar = value;
    });
  }

//=================================== Show Popup Menu =====================================\\

//Show popup menu
  void showPopupMenu(BuildContext context) {
    // final RenderBox overlay =
    //     Overlay.of(context).context.findRenderObject() as RenderBox;
    const position = RelativeRect.fromLTRB(10, 60, 0, 0);

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        PopupMenuItem<String>(
          value: 'rate',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FaIcon(FontAwesomeIcons.solidStar, color: kStarColor),
              kWidthSizedBox,
              const Text("Rate this vendor"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'report',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FaIcon(FontAwesomeIcons.solidFlag, color: kAccentColor),
              kWidthSizedBox,
              const Text("Report this vendor"),
            ],
          ),
        ),
      ],
    ).then((value) {
      // Handle the selected value from the popup menu
      if (value != null) {
        switch (value) {
          case 'rate':
            openRatingDialog(context);
            break;
          case 'report':
            Get.to(
              () => ReportBusiness(vendor: widget.vendor),
              routeName: 'ReportBusiness',
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
            break;
        }
      }
    });
  }

//================================ Rating Dialog ======================================\\
  openRatingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetAnimationCurve: Curves.easeIn,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultPadding)),
          elevation: 50,
          child: RateVendorDialog(vendor: widget.vendor),
        );
      },
    );
    setState(() {});
  }

//=================================== Navigation =====================================\\

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        appBar: MyAppBar(
          title: isScrollToTopBtnVisible
              ? widget.vendor.shopName
              : "Vendor Details",
          elevation: 0.0,
          backgroundColor: kPrimaryColor,
          actions: [
            IconButton(
              onPressed: _addToFavorites,
              icon: FaIcon(
                _isAddedToFavorites
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                color: kAccentColor,
              ),
            ),
            IconButton(
              onPressed: () => showPopupMenu(context),
              icon: FaIcon(
                FontAwesomeIcons.ellipsisVertical,
                color: kAccentColor,
              ),
            ),
          ],
        ),
        floatingActionButton: isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: FaIcon(FontAwesomeIcons.chevronUp,
                    size: 18, color: kPrimaryColor),
              )
            : const SizedBox(),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            child: ListView(
              controller: scrollController,
              physics: const ScrollPhysics(),
              children: [
                SizedBox(
                  height:
                      deviceType(media.width) > 2 && deviceType(media.width) < 4
                          ? 540
                          : deviceType(media.width) > 2
                              ? 470
                              : 370,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: deviceType(media.width) > 3 &&
                                  deviceType(media.width) < 5
                              ? media.height * 0.4
                              : deviceType(media.width) > 2
                                  ? media.height * 0.415
                                  : media.height * 0.28,
                          decoration: BoxDecoration(
                            color: kPageSkeletonColor,
                            // image: const DecorationImage(
                            //   fit: BoxFit.fill,
                            //   image: AssetImage(
                            //     "assets/images/vendors/ntachi-osa.png",
                            //   ),
                            // ),
                          ),
                          child: MyImage(
                            url: widget.vendor.shopImage,
                            radiusBottom: 0,
                          ),
                        ),
                      ),
                      Positioned(
                        top: deviceType(media.width) > 2
                            ? media.height * 0.25
                            : media.height * 0.13,
                        left: kDefaultPadding,
                        right: kDefaultPadding,
                        child: Container(
                          padding: const EdgeInsets.all(kDefaultPadding / 2),
                          decoration: ShapeDecoration(
                            shadows: [
                              BoxShadow(
                                color: kBlackColor.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal,
                              ),
                            ],
                            color: const Color(0xFFFEF8F8),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 0.50,
                                color: Color(0xFFFDEDED),
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: kDefaultPadding * 2.6),
                            child: SizedBox(
                              width: media.width - 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: media.width - 200,
                                    child: Text(
                                      widget.vendor.shopName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: kTextBlackColor,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  kHalfSizedBox,
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.locationDot,
                                          color: kAccentColor,
                                          size: 15,
                                        ),
                                        kHalfWidthSizedBox,
                                        Text(
                                          widget.vendor.address,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  kHalfSizedBox,
                                  InkWell(
                                    onTap: widget.vendor.address.isEmpty
                                        ? null
                                        : _toBusinessLocation,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                          kDefaultPadding / 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: kAccentColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        widget.vendor.address.isEmpty
                                            ? "Not Available"
                                            : "Show on map",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  kHalfSizedBox,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: media.width * 0.23,
                                        height: 57,
                                        decoration: ShapeDecoration(
                                          color: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(19),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.solidStar,
                                              color: kStarColor,
                                              size: 17,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${(widget.vendor.vendorOwner.averageRating).toPrecision(1)}',
                                              style: const TextStyle(
                                                color: kBlackColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: -0.28,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: media.width * 0.25,
                                        height: 57,
                                        decoration: ShapeDecoration(
                                          color: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(19),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.vendor.vendorOwner.isOnline
                                                  ? "Online"
                                                  : 'Offline',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: widget.vendor.vendorOwner
                                                        .isOnline
                                                    ? kSuccessColor
                                                    : kAccentColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: -0.36,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            FaIcon(
                                              Icons.info,
                                              color: kAccentColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: deviceType(media.width) > 3 &&
                                deviceType(media.width) < 5
                            ? media.height * 0.15
                            : deviceType(media.width) > 2
                                ? media.height * 0.15
                                : media.height * 0.08,
                        left: deviceType(media.width) > 2
                            ? (media.width / 2) - (126 / 2)
                            : (media.width / 2) - (100 / 2),
                        child: Container(
                          width: deviceType(media.width) > 2 ? 126 : 100,
                          height: deviceType(media.width) > 2 ? 126 : 100,
                          decoration: ShapeDecoration(
                            color: kPageSkeletonColor,
                            // image: const DecorationImage(
                            //   image: AssetImage(
                            //     "assets/images/vendors/ntachi-osa-logo.png",
                            //   ),
                            //   fit: BoxFit.cover,
                            // ),
                            shape: const OvalBorder(),
                          ),
                          child: MyImage(url: widget.vendor.coverImage),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: deviceType(media.width) > 2
                      ? const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 6)
                      : const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 1.5),
                  child: Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: kDefaultCategoryBackgroundColor,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: kLightGreyColor,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TabBar(
                            controller: _tabBarController,
                            onTap: (value) => _clickOnTabBarOption(value),
                            splashBorderRadius: BorderRadius.circular(50),
                            enableFeedback: true,
                            mouseCursor: SystemMouseCursors.click,
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: kTransparentColor,
                            automaticIndicatorColorAdjustment: true,
                            labelColor: kPrimaryColor,
                            unselectedLabelColor: kTextGreyColor,
                            indicator: BoxDecoration(
                              color: kAccentColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            tabs: const [
                              Tab(text: "Products"),
                              Tab(text: "About"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                kSizedBox,
                refreshing
                    ? Center(
                        child: CircularProgressIndicator(
                        color: kAccentColor,
                      ))
                    : Container(
                        padding: deviceType(media.width) > 2
                            ? const EdgeInsets.symmetric(horizontal: 20)
                            : const EdgeInsets.symmetric(horizontal: 10),
                        child: _selectedtabbar == 0
                            ? BusinessProducts(
                                vendor: widget.vendor,
                              )
                            : AboutBusiness(
                                vendor: widget.vendor,
                              ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
