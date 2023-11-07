// ignore_for_file: unused_local_variable
import 'package:benji/app/vendor/vendor_details.dart';
import 'package:benji/src/components/appbar/my_appbar.dart';
import 'package:benji/src/components/product/product_card.dart';
import 'package:benji/src/components/snackbar/my_floating_snackbar.dart';
import 'package:benji/src/repo/models/vendor/vendor.dart';
import 'package:benji/src/repo/utils/favorite.dart';
import 'package:benji/src/repo/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/route_manager.dart';

import '../../src/components/vendor/vendors_card.dart';
import '../../src/others/cart_card.dart';
import '../../src/others/empty.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/my_liquid_refresh.dart';
import '../../src/providers/responsive_constant.dart';
import '../../src/repo/models/product/product.dart';
import '../../theme/colors.dart';
import '../product/product_detail_screen.dart';
import 'favorite_products.dart';
import 'favorite_vendors.dart';

class Favorites extends StatefulWidget {
  final String vendorCoverImage;
  final String vendorName;
  final double vendorRating;
  final String vendorActiveStatus;
  final Color vendorActiveStatusColor;
  const Favorites({
    super.key,
    required this.vendorCoverImage,
    required this.vendorName,
    required this.vendorRating,
    required this.vendorActiveStatus,
    required this.vendorActiveStatusColor,
  });

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites>
    with SingleTickerProviderStateMixin {
  //=================================== ALL VARIABLES ====================================\\
  //======================================================================================\\
  @override
  void initState() {
    super.initState();
    checkAuth(context);
    _products = _getDataProduct();
    _vendors = _getDataVendor();
    _tabBarController = TabController(length: 2, vsync: this);
  }

  late Future<List<Product>> _products;
  late Future<List<VendorModel>> _vendors;

  Future<List<Product>> _getDataProduct() async {
    List<Product> product = await getFavoriteProduct(
      (data) => mySnackBar(
        context,
        kAccentColor,
        "Error!",
        "Item with id $data not found",
        const Duration(
          seconds: 1,
        ),
      ),
    );

    return product;
  }

  Future<List<VendorModel>> _getDataVendor() async {
    List<VendorModel> vendor = await getFavoriteVendor(
      (data) => mySnackBar(
        context,
        kAccentColor,
        "Error!",
        "Item with id $data not found",
        const Duration(
          seconds: 1,
        ),
      ),
    );

    return vendor;
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _products = _getDataProduct();
      _vendors = _getDataVendor();
    });
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

//==========================================================================================\\

  //=================================== CONTROLLERS ====================================\\
  late TabController _tabBarController;
  final ScrollController _scrollController = ScrollController();

//===================== Tabs ==========================\\
  int _selectedtabbar = 0;
  void _clickOnTabBarOption(value) async {
    setState(() {
      _selectedtabbar = value;
    });
  }
  //===================== Navigation ==========================\\

  void _toProductDetailsScreen(product) async {
    await Get.to(
      () => ProductDetailScreen(product: product),
      routeName: 'ProductDetailScreen',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    setState(() {
      _products = _getDataProduct();
    });
  }

  void _vendorDetailPage(vendor) async {
    await Get.to(
      () => VendorDetails(vendor: vendor),
      routeName: 'VendorDetails',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    setState(() {
      _vendors = _getDataVendor();
    });
  }
//====================================================================================\\

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    var media = MediaQuery.of(context).size;

//====================================================================================\\

    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: "Favorites",
          elevation: 0.0,
          actions: const [CartCard(), kHalfWidthSizedBox],
          backgroundColor: kPrimaryColor,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              kSizedBox,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                ),
                child: Container(
                  width: media.width,
                  decoration: BoxDecoration(
                    color: kDefaultCategoryBackgroundColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: kGreyColor1,
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
                          enableFeedback: true,
                          mouseCursor: SystemMouseCursors.click,
                          automaticIndicatorColorAdjustment: true,
                          overlayColor: MaterialStatePropertyAll(kAccentColor),
                          labelColor: kPrimaryColor,
                          unselectedLabelColor: kTextGreyColor,
                          indicatorColor: kAccentColor,
                          indicatorWeight: 2,
                          splashBorderRadius: BorderRadius.circular(50),
                          indicator: BoxDecoration(
                            color: kAccentColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          tabs: const [
                            Tab(text: "Products"),
                            Tab(text: "Vendors"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              kSizedBox,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding / 2,
                ),
                width: media.width,
                child: _selectedtabbar == 0
                    ? FutureBuilder(
                        future: _products,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Scrollbar(
                              controller: _scrollController,
                              radius: const Radius.circular(10),
                              child: FavoriteProductsTab(
                                list: snapshot.data!.isEmpty
                                    ? const EmptyCard()
                                    : LayoutGrid(
                                        rowGap: kDefaultPadding / 2,
                                        columnGap: kDefaultPadding / 2,
                                        columnSizes: breakPointDynamic(
                                            media.width,
                                            [1.fr],
                                            [1.fr, 1.fr],
                                            [1.fr, 1.fr, 1.fr],
                                            [1.fr, 1.fr, 1.fr, 1.fr]),
                                        rowSizes: snapshot.data!.isEmpty
                                            ? [auto]
                                            : List.generate(
                                                snapshot.data!.length,
                                                (index) => auto),
                                        children:
                                            (snapshot.data as List<Product>)
                                                .map(
                                                  (item) => ProductCard(
                                                    onTap: () =>
                                                        _toProductDetailsScreen(
                                                            item),
                                                    product: item,
                                                  ),
                                                )
                                                .toList(),
                                      ),
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              color: kAccentColor,
                            ),
                          );
                        },
                      )
                    : FutureBuilder(
                        future: _vendors,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return FavoriteVendorsTab(
                              list: Scrollbar(
                                controller: _scrollController,
                                radius: const Radius.circular(10),
                                child: snapshot.data!.isEmpty
                                    ? const EmptyCard()
                                    : LayoutGrid(
                                        rowGap: kDefaultPadding / 2,
                                        columnGap: kDefaultPadding / 2,
                                        columnSizes: breakPointDynamic(
                                            media.width,
                                            [1.fr],
                                            [1.fr, 1.fr],
                                            [1.fr, 1.fr, 1.fr],
                                            [1.fr, 1.fr, 1.fr, 1.fr]),
                                        rowSizes: snapshot.data!.isEmpty
                                            ? [auto]
                                            : List.generate(
                                                snapshot.data!.length,
                                                (index) => auto),
                                        children:
                                            (snapshot.data as List<VendorModel>)
                                                .map(
                                                  (item) => VendorsCard(
                                                      removeDistance: true,
                                                      onTap: () {
                                                        _vendorDetailPage(item);
                                                      },
                                                      vendorName: item.shopName,
                                                      typeOfBusiness:
                                                          item.shopType.name,
                                                      rating:
                                                          " ${((item.averageRating)).toStringAsPrecision(2).toString()} (${(item.numberOfClientsReactions).toString()})",
                                                      cardImage:
                                                          "assets/images/vendors/ntachi-osa.png"),
                                                )
                                                .toList(),
                                      ),
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              color: kAccentColor,
                            ),
                          );
                        }),
              ),
              kHalfSizedBox,
            ],
          ),
        ),
      ),
    );
  }
}
