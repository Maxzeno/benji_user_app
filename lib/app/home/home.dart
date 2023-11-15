// ignore_for_file: unused_field

import 'dart:math';

import 'package:benji/app/cart/cart_screen.dart';
import 'package:benji/app/favorites/favorites.dart';
import 'package:benji/app/packages/send_package.dart';
import 'package:benji/app/support/help_and_support.dart';
import 'package:benji/src/components/vendor/vendors_card.dart';
import 'package:benji/src/others/empty.dart';
import 'package:benji/src/others/my_future_builder.dart';
import 'package:benji/src/repo/controller/address_controller.dart';
import 'package:benji/src/repo/controller/category_controller.dart';
import 'package:benji/src/repo/controller/product_controller.dart';
import 'package:benji/src/repo/controller/sub_category_controller.dart';
import 'package:benji/src/repo/controller/vendor_controller.dart';
import 'package:benji/src/repo/models/address/address_model.dart';
import 'package:benji/src/repo/models/category/category.dart';
import 'package:benji/src/repo/utils/helpers.dart';
import 'package:benji/src/skeletons/app/card.dart';
import 'package:benji/src/skeletons/page_skeleton.dart';
import 'package:flutter/foundation.dart' as fnd;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../src/components/appbar/appbar_delivery_location.dart';
import '../../src/components/product/product_card.dart';
import '../../src/components/section/category_items.dart';
import '../../src/components/section/custom_show_search.dart';
import '../../src/components/section/see_all_container.dart';
import '../../src/components/simple_item/category_item.dart';
import '../../src/components/snackbar/my_floating_snackbar.dart';
import '../../src/others/cart_card.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../src/repo/controller/notifications_controller.dart';
import '../../src/repo/models/vendor/vendor.dart';
import '../../theme/colors.dart';
import '../address/addresses.dart';
import '../orders/order_history.dart';
import '../product/home_page_products.dart';
import '../product/product_detail_screen.dart';
import '../settings/settings.dart';
import '../vendor/popular_vendors.dart';
import '../vendor/vendor_details.dart';
import '../vendor/vendors_near_you.dart';
import 'home_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    checkAuth(context);
    if (!fnd.kIsWeb) {
      NotificationController.initializeNotification();
    }

    _currentAddress = getCurrentAddress();
    _scrollController.addListener(_scrollListener);
    _scrollController.addListener(() =>
        ProductController.instance.scrollListenerProduct(_scrollController));
  }

  late Future<Address> _currentAddress;

  @override
  void dispose() {
    _scrollController.dispose();
    _carouselController.stopAutoPlay();
    _scrollController.removeListener(() {});

    super.dispose();
  }

//============================================== ALL VARIABLES =================================================\\
  int start = 0;
  int end = 10;
  bool loadMore = false;
  bool thatsAllData = false;

  String activeCategory = '';
  String cartCount = '';

//============================================== BOOL VALUES =================================================\\
  final bool _vendorStatus = true;
  bool _isScrollToTopBtnVisible = false;

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

  //==================================================== CONTROLLERS ======================================================\\
  final _scrollController = ScrollController();
  final CarouselController _carouselController = CarouselController();

//===================== Images =======================\\

  final List<String> _carouselImages = <String>[
    "assets/images/products/best-choice-restaurant.png",
    "assets/images/products/burgers.png",
    "assets/images/products/chizzy_food.png",
    "assets/images/products/golden-toast.png",
    "assets/images/products/new-food.png",
    "assets/images/products/okra-soup.png",
    "assets/images/products/pasta.png"
  ];

  final List<String> popularVendorImage = [
    "assets/images/vendors/ntachi-osa.png",
    "assets/images/vendors/ntachi-osa.png",
    "assets/images/vendors/ntachi-osa.png",
    "assets/images/vendors/ntachi-osa.png",
    "assets/images/vendors/ntachi-osa.png",
  ];

  //===================== COPY TO CLIPBOARD =======================\\
  void _copyToClipboard(BuildContext context, String userID) {
    Clipboard.setData(
      ClipboardData(text: userID),
    );

    //===================== SNACK BAR =======================\\

    mySnackBar(
      context,
      kSuccessColor,
      "Success!",
      "ID copied to clipboard",
      const Duration(seconds: 2),
    );
  }

  //===================== Scroll to Top ==========================\\
  Future<void> _scrollToTop() async {
    await _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isScrollToTopBtnVisible = false;
    });
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels >= 200 &&
        _isScrollToTopBtnVisible != true) {
      setState(() {
        _isScrollToTopBtnVisible = true;
      });
    }
    if (_scrollController.position.pixels < 200 &&
        _isScrollToTopBtnVisible == true) {
      setState(() {
        _isScrollToTopBtnVisible = false;
      });
    }
  }

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _currentAddress = getCurrentAddress();
    });
  }
  //========================================================================\\

  //==================================================== Navigation ===========================================================\\
  void _toHelpAndSupport() => Get.to(
        () => const HelpAndSupport(),
        routeName: 'HelpAndSupport',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toSettings() async {
    await Get.to(
      () => const Settings(),
      routeName: 'Settings',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    setState(() {});
  }

  void _toAddressScreen() => Get.to(
        () => const Addresses(),
        routeName: 'Addresses',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toFavoritesScreen() => Get.to(
        () => Favorites(
          vendorCoverImage:
              _vendorStatus ? _onlineVendorsImage : _offlineVendorsImage,
          vendorName: _vendorStatus ? _onlineVendorsName : _offlineVendorsName,
          vendorRating:
              _vendorStatus ? _onlineVendorsRating : _offlineVendorsRating,
          vendorActiveStatus: _vendorStatus ? _vendorActive : _vendorInactive,
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
  void _toOrdersScreen() => Get.to(
        () => const OrdersHistory(),
        routeName: 'OrdersHistory',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toCheckoutScreen() => Get.to(
        () => const CartScreen(),
        routeName: 'CartScreen',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
  void _toSeeAllVendorsNearYou() => Get.to(
        () => const VendorsNearYou(),
        routeName: 'VendorsNearYou',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toVendorPage(VendorModel vendor) => Get.to(
        () => VendorDetails(vendor: vendor),
        routeName: 'VendorDetails',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toSeeAllPopularVendors() => Get.to(
        () => const PopularVendors(),
        routeName: 'PopularVendors',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
  void _toAddressesPage() => Get.to(
        () => const Addresses(),
        routeName: 'Addresses',
        duration: const Duration(milliseconds: 1000),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.cupertinoDialog,
      );

  void _toProductDetailScreenPage(product) async {
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
    setState(() {});
  }

  void _toSeeProducts(
    Category category, {
    String id = '',
  }) {
    SubCategoryController.instance.setCategory(category);
    Get.to(
      () => HomePageProducts(activeCategory: id),
      routeName: 'HomePageProducts',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  void _toPackagesPage() => Get.to(
        () => const SendPackage(),
        routeName: 'SendPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        onDrawerChanged: (isOpened) {
          setState(() {});
        },
        drawerDragStartBehavior: DragStartBehavior.start,
        drawerEnableOpenDragGesture: true,
        endDrawerEnableOpenDragGesture: true,
        resizeToAvoidBottomInset: true,
        drawer: MyFutureBuilder(
          future: getUser(),
          child: (data) => HomeDrawer(
            userID: data.code,
            toSettings: _toSettings,
            copyUserIdToClipBoard: () {
              _copyToClipboard(context, data.code);
            },
            toAddressesPage: _toAddressScreen,
            toPackagesPage: _toPackagesPage,
            toFavoritesPage: _toFavoritesScreen,
            toCheckoutScreen: _toCheckoutScreen,
            toOrdersPage: _toOrdersScreen,
            helpAndSupport: _toHelpAndSupport,
          ),
        ),
        floatingActionButton: _isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: _scrollToTop,
                mini: deviceType(media.width) > 2 ? false : true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const FaIcon(FontAwesomeIcons.chevronUp, size: 18),
              )
            : const SizedBox(),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0.0,
          toolbarHeight: kToolbarHeight,
          title: Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Image.asset(
                    "assets/icons/drawer-icon.png",
                    color: kAccentColor,
                    fit: BoxFit.cover,
                    height: deviceType(media.width) > 2 ? 25 : 20,
                  ),
                ),
              ),
              GetBuilder<AddressController>(builder: (controller) {
                if (controller.isLoad.value &&
                    controller.current.value.id == '0') {
                  return AppBarDeliveryLocation(
                    deliveryLocation: 'Loading...',
                    toDeliverToPage: () {},
                  );
                }
                return AppBarDeliveryLocation(
                  deliveryLocation: controller.current.value.title,
                  toDeliverToPage: _toAddressesPage,
                );
              }),
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
              icon: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: kAccentColor,
                size: 24,
              ),
            ),
            // ignore: prefer_const_constructors
            CartCard(),
            kHalfWidthSizedBox
          ],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: kAccentColor,
            semanticsLabel: "Pull to refresh",
            child: Scrollbar(
              controller: _scrollController,
              child: ListView(
                // controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: deviceType(media.width) > 2
                    ? const EdgeInsets.all(kDefaultPadding)
                    : const EdgeInsets.all(kDefaultPadding / 2),
                children: [
                  FutureBuilder(
                      //this shold be hot deals and not _popularVendors
                      future: null,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            highlightColor: kBlackColor.withOpacity(0.9),
                            baseColor: kBlackColor.withOpacity(0.6),
                            direction: ShimmerDirection.ltr,
                            child: PageSkeleton(
                                height: 150, width: media.width - 20),
                          );
                        }
                        return FlutterCarousel.builder(
                          options: CarouselOptions(
                            height: media.height * 0.25,
                            viewportFraction: 1.0,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 2),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.easeInOut,
                            enlargeCenterPage: true,
                            controller: _carouselController,
                            onPageChanged: (index, value) {
                              setState(() {});
                            },
                            pageSnapping: true,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            scrollBehavior: const ScrollBehavior(),
                            pauseAutoPlayOnTouch: true,
                            pauseAutoPlayOnManualNavigate: true,
                            pauseAutoPlayInFiniteScroll: false,
                            enlargeStrategy: CenterPageEnlargeStrategy.scale,
                            disableCenter: false,
                            showIndicator: true,
                            floatingIndicator: true,
                            slideIndicator: CircularSlideIndicator(
                              alignment: Alignment.bottomCenter,
                              currentIndicatorColor: kAccentColor,
                              indicatorBackgroundColor: kPrimaryColor,
                              indicatorRadius: 5,
                              padding: const EdgeInsets.all(0),
                            ),
                          ),
                          itemCount: _carouselImages.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              width: media.width,
                              decoration: ShapeDecoration(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    _carouselImages[itemIndex],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  kSizedBox,
                  // categories
                  Container(
                    width: media.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: kLightGreyColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Vendors".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: kTextBlackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.40,
                        ),
                      ),
                    ),
                  ),
                  kSizedBox,
                  GetBuilder<CategoryController>(builder: (controller) {
                    if (controller.isLoad.value &&
                        controller.category.isEmpty) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Shimmer.fromColors(
                                highlightColor: kBlackColor.withOpacity(0.9),
                                baseColor: kBlackColor.withOpacity(0.6),
                                direction: ShimmerDirection.ltr,
                                child: PageSkeleton(
                                    height: 35, width: media.width / 7),
                              ),
                              kWidthSizedBox,
                              Shimmer.fromColors(
                                highlightColor: kBlackColor.withOpacity(0.9),
                                baseColor: kBlackColor.withOpacity(0.6),
                                direction: ShimmerDirection.ltr,
                                child: PageSkeleton(
                                    height: 35, width: media.width / 7),
                              ),
                              kWidthSizedBox,
                              Shimmer.fromColors(
                                highlightColor: kBlackColor.withOpacity(0.9),
                                baseColor: kBlackColor.withOpacity(0.6),
                                direction: ShimmerDirection.ltr,
                                child: PageSkeleton(
                                    height: 35, width: media.width / 7),
                              ),
                              kWidthSizedBox,
                              Shimmer.fromColors(
                                  highlightColor: kBlackColor.withOpacity(0.9),
                                  baseColor: kBlackColor.withOpacity(0.6),
                                  direction: ShimmerDirection.ltr,
                                  child: PageSkeleton(
                                      height: 35, width: media.width / 9)),
                            ],
                          ),
                          kSizedBox,
                        ],
                      );
                    }

                    return LayoutGrid(
                      columnGap: 10,
                      rowGap: 10,
                      columnSizes: breakPointDynamic(
                        media.width,
                        List.filled(4, 1.fr),
                        List.filled(4, 1.fr),
                        List.filled(8, 1.fr),
                        List.filled(8, 1.fr),
                      ),
                      rowSizes: const [auto, auto],
                      children: List.generate(
                          min(8, controller.category.length + 1),
                          (index) => index).map(
                        (item) {
                          int value = min(7, controller.category.length);
                          if (item == value) {
                            return CategoryItem(
                              nav: () => showModalBottomSheet(
                                context: context,
                                elevation: 20,
                                barrierColor: kBlackColor.withOpacity(0.6),
                                showDragHandle: true,
                                useSafeArea: true,
                                isDismissible: true,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(
                                      kDefaultPadding,
                                    ),
                                  ),
                                ),
                                enableDrag: true,
                                builder: (builder) => CategoryItemSheet(
                                    category: controller.category),
                              ),
                            );
                          }
                          return CategoryItem(
                            category: controller.category[item],
                            nav: () => _toSeeProducts(controller.category[item],
                                id: controller.category[item].id),
                          );
                        },
                      ).toList(),
                    );
                  }),
                  SeeAllContainer(
                    title: "Vendors Near you",
                    onPressed: _toSeeAllVendorsNearYou,
                  ),
                  kSizedBox,
                  GetBuilder<VendorController>(builder: (controller) {
                    if (controller.isLoad.value &&
                        controller.vendorList.isEmpty) {
                      return const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CardSkeleton(height: 200, width: 200),
                            kHalfWidthSizedBox,
                            CardSkeleton(height: 200, width: 200),
                            kHalfWidthSizedBox,
                            CardSkeleton(height: 200, width: 200),
                          ],
                        ),
                      );
                    }
                    return SizedBox(
                      height: 250,
                      width: media.width,
                      child: ListView.separated(
                        itemCount: controller.vendorList.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            deviceType(media.width) > 2
                                ? kWidthSizedBox
                                : kHalfWidthSizedBox,
                        itemBuilder: (context, index) => InkWell(
                          child: SizedBox(
                            width: 200,
                            child: VendorsCard(
                              removeDistance: false,
                              onTap: () {
                                _toVendorPage(controller.vendorList[index]);
                              },
                              cardImage: "assets/images/vendors/ntachi-osa.png",
                              vendorName: controller.vendorList[index].shopName,
                              typeOfBusiness:
                                  controller.vendorList[index].shopType.name,
                              rating:
                                  '${(controller.vendorList[index].averageRating).toStringAsPrecision(2)} (${controller.vendorList[index].numberOfClientsReactions})',
                              distance: "30 mins",
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  kSizedBox,
                  SeeAllContainer(
                    title: "Popular Vendors",
                    onPressed: _toSeeAllPopularVendors,
                  ),
                  kSizedBox,
                  GetBuilder<VendorController>(builder: (controller) {
                    if (controller.isLoad.value &&
                        controller.vendorPopularList.isEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.filled(
                          breakPoint(
                            media.width,
                            1,
                            2,
                            3,
                            4,
                          ).toInt(),
                          CardSkeleton(
                              height: 200,
                              width: (media.width /
                                      breakPoint(
                                        media.width,
                                        1,
                                        2,
                                        3,
                                        4,
                                      )) -
                                  20),
                        ),
                      );
                    }

                    return LayoutGrid(
                      rowGap: kDefaultPadding / 2,
                      columnGap: kDefaultPadding / 2,
                      columnSizes: breakPointDynamic(
                          media.width,
                          [1.fr],
                          [1.fr, 1.fr],
                          [1.fr, 1.fr, 1.fr],
                          [1.fr, 1.fr, 1.fr, 1.fr]),
                      rowSizes: controller.vendorPopularList.isEmpty
                          ? [auto]
                          : List.generate(controller.vendorPopularList.length,
                              (index) => auto),
                      children: (controller.vendorPopularList)
                          .map(
                            (item) => VendorsCard(
                                removeDistance: true,
                                onTap: () {
                                  _toVendorPage(item);
                                },
                                vendorName: item.shopName,
                                typeOfBusiness: item.shopType.name,
                                rating:
                                    " ${((item.averageRating)).toStringAsPrecision(2).toString()} (${(item.numberOfClientsReactions).toString()})",
                                cardImage:
                                    "assets/images/vendors/ntachi-osa.png"),
                          )
                          .toList(),
                    );
                  }),
                  kSizedBox,
                  Container(
                    width: media.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: kLightGreyColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Products Category".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: kTextBlackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.40,
                        ),
                      ),
                    ),
                  ),
                  kSizedBox,
                  GetBuilder<CategoryController>(builder: (controller) {
                    if (controller.isLoad.value &&
                        controller.category.isEmpty) {
                      return Column(
                        children: [
                          kSizedBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Shimmer.fromColors(
                                highlightColor: kBlackColor.withOpacity(0.9),
                                baseColor: kBlackColor.withOpacity(0.6),
                                direction: ShimmerDirection.ltr,
                                child: PageSkeleton(
                                    height: 35, width: media.width / 7),
                              ),
                              kWidthSizedBox,
                              Shimmer.fromColors(
                                highlightColor: kBlackColor.withOpacity(0.9),
                                baseColor: kBlackColor.withOpacity(0.6),
                                direction: ShimmerDirection.ltr,
                                child: PageSkeleton(
                                    height: 35, width: media.width / 7),
                              ),
                              kWidthSizedBox,
                              Shimmer.fromColors(
                                highlightColor: kBlackColor.withOpacity(0.9),
                                baseColor: kBlackColor.withOpacity(0.6),
                                direction: ShimmerDirection.ltr,
                                child: PageSkeleton(
                                    height: 35, width: media.width / 7),
                              ),
                              kWidthSizedBox,
                              Shimmer.fromColors(
                                  highlightColor: kBlackColor.withOpacity(0.9),
                                  baseColor: kBlackColor.withOpacity(0.6),
                                  direction: ShimmerDirection.ltr,
                                  child: PageSkeleton(
                                      height: 35, width: media.width / 9)),
                            ],
                          ),
                          kSizedBox,
                        ],
                      );
                    }

                    return LayoutGrid(
                      columnGap: 10,
                      rowGap: 10,
                      columnSizes: breakPointDynamic(
                        media.width,
                        List.filled(4, 1.fr),
                        List.filled(4, 1.fr),
                        List.filled(8, 1.fr),
                        List.filled(8, 1.fr),
                      ),
                      rowSizes: const [auto, auto],
                      children: List.generate(
                          min(8, controller.category.length + 1),
                          (index) => index).map(
                        (item) {
                          int value = min(7, controller.category.length);
                          if (item == value) {
                            return CategoryItem(
                              nav: () => showModalBottomSheet(
                                context: context,
                                elevation: 20,
                                barrierColor: kBlackColor.withOpacity(0.6),
                                showDragHandle: true,
                                useSafeArea: true,
                                isDismissible: true,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(
                                      kDefaultPadding,
                                    ),
                                  ),
                                ),
                                enableDrag: true,
                                builder: (builder) => CategoryItemSheet(
                                    isShop: false,
                                    category: controller.category),
                              ),
                            );
                          }
                          return CategoryItem(
                            isShop: false,
                            category: controller.category[item],
                            nav: () => _toSeeProducts(controller.category[item],
                                id: controller.category[item].id),
                          );
                        },
                      ).toList(),
                    );
                  }),
                  kSizedBox,

                  GetBuilder<ProductController>(
                    builder: (controller) {
                      if (controller.isLoad.value &&
                          controller.products.isEmpty) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.filled(
                            breakPoint(
                              media.width,
                              1,
                              2,
                              3,
                              4,
                            ).toInt(),
                            CardSkeleton(
                                height: 200,
                                width: (media.width /
                                        breakPoint(
                                          media.width,
                                          1,
                                          2,
                                          3,
                                          4,
                                        )) -
                                    20),
                          ),
                        );
                      }
                      if (controller.products.isEmpty) {
                        return const EmptyCard(
                          removeButton: true,
                        );
                      }
                      return Column(
                        children: [
                          LayoutGrid(
                            rowGap: kDefaultPadding / 2,
                            columnGap: kDefaultPadding / 2,
                            columnSizes: breakPointDynamic(
                                media.width,
                                [1.fr],
                                [1.fr, 1.fr],
                                [1.fr, 1.fr, 1.fr],
                                [1.fr, 1.fr, 1.fr, 1.fr]),
                            rowSizes: controller.products.isEmpty
                                ? [auto]
                                : List.generate(controller.products.length,
                                    (index) => auto),
                            children: (controller.products)
                                .map(
                                  (item) => ProductCard(
                                    product: item,
                                    onTap: () =>
                                        _toProductDetailScreenPage(item),
                                  ),
                                )
                                .toList(),
                          ),
                          kHalfSizedBox,
                          ProductController.instance.loadedAllProduct.value
                              ? Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  height: 10,
                                  width: 10,
                                  decoration: ShapeDecoration(
                                      shape: const CircleBorder(),
                                      color: kPageSkeletonColor),
                                )
                              : const SizedBox(),
                          ProductController.instance.isLoadMoreProduct.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: kAccentColor,
                                  ),
                                )
                              : const SizedBox()
                        ],
                      );
                    },
                  ),

                  kSizedBox,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
