import 'package:benji_user/app/favorites/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/appBar_delivery_location.dart';
import '../../src/common_widgets/category_button_section.dart';
import '../../src/common_widgets/custom_showSearch.dart';
import '../../src/common_widgets/home_hot_deals.dart';
import '../../src/common_widgets/home_popular_vendors_card.dart';
import '../../src/common_widgets/homepage_vendors.dart';
import '../../src/common_widgets/my_floating_snackbar.dart';
import '../../src/common_widgets/see_all_container.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../address/address.dart';
import '../auth/login.dart';
import '../cart/cart.dart';
import '../orders/order_history.dart';
import '../product/hot_deals.dart';
import '../profile/edit_profile.dart';
import '../send_package/send_package.dart';
import '../vendors/popular_vendors.dart';
import '../vendors/vendors_near_you.dart';
import 'home_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
//============================================== ALL VARIABLES =================================================\\
  bool _vendorStatus = true;

  //Online Vendors
  final String _onlineVendorsName = "Ntachi Osa";
  final String _onlineVendorsImage = "ntachi-osa";
  final double _onlineVendorsRating = 4.6;

  final String _vendorActive = "Online";
  final String _vendorInactive = "Offline";
  final Color _vendorActiveColor = kSuccessColor;
  final Color _vendorInactiveColor = kAccentColor;

  //Offline Vendors
  final String _offlineVendorsName = "Best Choice Restaurant";
  final String _offlineVendorsImage = "best-choice-restaurant";
  final double _offlineVendorsRating = 4.0;

  //===================== TEXTEDITING CONTROLLER =======================\\
  TextEditingController searchController = TextEditingController();

  //===================== CATEGORY BUTTONS =======================\\
  final List _categoryButton = [
    "Food",
    "Drinks",
    "Groceries",
    "Pharmaceuticals",
    "Snacks",
  ];

  final List<Color> _categoryButtonBgColor = [
    kAccentColor,
    Color(0xFFF2F2F2),
    Color(0xFFF2F2F2),
    Color(0xFFF2F2F2),
    Color(0xFFF2F2F2),
  ];
  final List<Color> _categoryButtonFontColor = [
    kPrimaryColor,
    Color(0xFF828282),
    Color(0xFF828282),
    Color(0xFF828282),
    Color(0xFF828282),
  ];

//===================== POPULAR VENDORS =======================\\
  final List<int> popularVendorsIndex = [0, 1, 2, 3, 4];

  final List<String> popularVendorImage = [
    "best-choice-restaurant.png",
    "golden-toast.png",
    "best-choice-restaurant.png",
    "best-choice-restaurant.png",
    "best-choice-restaurant.png",
  ];
  final List<dynamic> popularVendorBannerColor = [
    kAccentColor,
    Color(0x00000000),
    kAccentColor,
    kAccentColor,
    kAccentColor,
  ];
  final List<dynamic> popularVendorBannerText = [
    "Free Delivery",
    "",
    "Free Delivery",
    "Free Delivery",
    "Free Delivery",
  ];

  final List<String> popularVendorName = [
    "Best Choice restaurant",
    "Golden Toast",
    "Best Choice restaurant",
    "Best Choice restaurant",
    "Best Choice restaurant",
  ];

  final List<String> popularVendorFood = [
    "Food",
    "Traditional",
    "Food",
    "Food",
    "Food",
  ];

  final List<String> popularVendorCategory = [
    "Fast Food",
    "Continental",
    "Fast Food",
    "Fast Food",
    "Fast Food",
  ];
  final List<String> popularVendorRating = [
    "3.6",
    "3.6",
    "3.6",
    "3.6",
    "3.6",
  ];
  final List<String> popularVendorNoOfUsersRating = [
    "500",
    "500",
    "500",
    "500",
    "500",
  ];

  //===================== COPY TO CLIPBOARD =======================\\
  final String userID = 'ID: 337890-AZQ';
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(
      ClipboardData(
        text: userID,
      ),
    );

    //===================== SNACK BAR =======================\\

    mySnackBar(
      context,
      "Success!",
      "Copied to clipboard",
      Duration(
        seconds: 2,
      ),
    );
  }

  //==================================================== FUNCTIONS ===========================================================\\
  void _logOut() => Get.offAll(
        () => const Login(logout: true),
        predicate: (route) => false,
        routeName: 'Login',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        drawer: HomeDrawer(
          userID: userID,
          toEditProfilePage: () {
            Get.to(
              () => const EditProfile(),
              routeName: 'EditProfile',
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
          },
          copyUserIdToClipBoard: () {
            _copyToClipboard(
              context,
            );
          },
          toAddressesPage: () {
            Get.to(
              () => const Addresses(),
              routeName: 'Addresses',
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
          },
          toSendPackagePage: () {
            Get.to(
              () => const SendPackage(),
              routeName: 'SendPackage',
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
          },
          toFavoritesPage: () {
            Get.to(
              () => Favorites(
                vendorCoverImage:
                    _vendorStatus ? _onlineVendorsImage : _offlineVendorsImage,
                vendorName:
                    _vendorStatus ? _onlineVendorsName : _offlineVendorsName,
                vendorRating: _vendorStatus
                    ? _onlineVendorsRating
                    : _offlineVendorsRating,
                vendorActiveStatus:
                    _vendorStatus ? _vendorActive : _vendorInactive,
                vendorActiveStatusColor:
                    _vendorStatus ? _vendorActiveColor : _vendorInactiveColor,
              ),
              routeName: 'SendPackage',
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
          },
          toInvitesPage: () {},
          toOrdersPage: () {
            Get.to(
              () => const OrdersHistory(),
              routeName: 'OrdersHistory',
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
          },
          logOut: _logOut,
        ),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          titleSpacing: kDefaultPadding / 2,
          elevation: 0.0,
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding / 2,
                ),
                child: Builder(
                  builder: (context) => IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Image.asset(
                      "assets/images/icons/drawer-icon.png",
                    ),
                  ),
                ),
              ),
              AppBarDeliveryLocation(
                deliveryLocation: 'Independence Layout, Enugu',
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: Icon(
                Icons.search_rounded,
                color: kAccentColor,
              ),
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      Get.to(
                        () => const Cart(),
                        routeName: 'Cart',
                        duration: const Duration(milliseconds: 300),
                        fullscreenDialog: true,
                        curve: Curves.easeIn,
                        preventDuplicates: true,
                        popGesture: true,
                        transition: Transition.rightToLeft,
                      );
                    },
                    splashRadius: 20,
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: kAccentColor,
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: ShapeDecoration(
                      color: kAccentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "10+",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            color: kPrimaryColor,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(
              kDefaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kHalfSizedBox,
                CategoryButtonSection(
                  category: _categoryButton,
                  categorybgColor: _categoryButtonBgColor,
                  categoryFontColor: _categoryButtonFontColor,
                ),
                SizedBox(height: 8),
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      SeeAllContainer(
                        title: "Vendors Near you",
                        onPressed: () {
                          Get.to(
                            () => const VendorsNearYou(),
                            routeName: 'VendorsNearYou',
                            duration: const Duration(milliseconds: 300),
                            fullscreenDialog: true,
                            curve: Curves.easeIn,
                            preventDuplicates: true,
                            popGesture: true,
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      kSizedBox,
                      HomePageVendorsCard(),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      SeeAllContainer(
                        title: "Popular Vendors",
                        onPressed: () {
                          Get.to(
                            () => const PopularVendors(),
                            routeName: 'PopularVendors',
                            duration: const Duration(milliseconds: 300),
                            fullscreenDialog: true,
                            curve: Curves.easeIn,
                            preventDuplicates: true,
                            popGesture: true,
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      kSizedBox,
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0;
                                i < popularVendorsIndex.length;
                                i++,)
                              PopularVendorsCard(
                                onTap: () {},
                                cardImage: popularVendorImage[i],
                                bannerColor: popularVendorBannerColor[i],
                                bannerText: popularVendorBannerText[i],
                                vendorName: popularVendorName[i],
                                food: popularVendorFood[i],
                                category: popularVendorCategory[i],
                                rating: popularVendorRating[i],
                                noOfUsersRated: popularVendorNoOfUsersRating[i],
                              ),
                          ],
                        ),
                      ),
                      kSizedBox,
                      SeeAllContainer(
                        title: "Hot Deals",
                        onPressed: () {
                          Get.to(
                            () => const HotDeals(),
                            routeName: 'HotDeals',
                            duration: const Duration(milliseconds: 300),
                            fullscreenDialog: true,
                            curve: Curves.easeIn,
                            preventDuplicates: true,
                            popGesture: true,
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      kSizedBox,
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < 5; i++,) HomeHotDeals(),
                          ],
                        ),
                      ),
                    ],
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
