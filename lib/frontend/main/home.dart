import 'dart:io';

import 'package:benji/frontend/store/categories.dart';
import 'package:benji/frontend/store/category.dart';
import 'package:benji/frontend/store/product.dart';
import 'package:benji/src/frontend/widget/clickable.dart';
import 'package:benji/src/frontend/widget/section/hero.dart';
import 'package:benji/src/frontend/widget/show_modal.dart';
import 'package:benji/src/frontend/widget/text/fancy_text.dart';
import 'package:benji/src/repo/models/category/category.dart';
import 'package:benji/src/repo/models/product/product.dart';
import 'package:benji/src/repo/utils/url_lunch.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart' as fnd;
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../src/frontend/model/category.dart';
import '../../src/frontend/model/product.dart';
import '../../src/frontend/utils/constant.dart';
import '../../src/frontend/widget/button.dart';
import '../../src/frontend/widget/cards/border_card.dart';
import '../../src/frontend/widget/cards/circle_card.dart';
import '../../src/frontend/widget/cards/image_card.dart';
import '../../src/frontend/widget/cards/product_card.dart';
import '../../src/frontend/widget/drawer/drawer.dart';
import '../../src/frontend/widget/end_to_end_row.dart';
import '../../src/frontend/widget/responsive/appbar/appbar.dart';
import '../../src/frontend/widget/section/footer.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarouselController buttonCarouselController = CarouselController();

  bool _showBackToTopButton = false;
  bool isLoading = true;
  String errrorMessage = "";

  // scroll controller
  late ScrollController _scrollController;

  int _crossAxisCount(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600) {
      return 1; // Small screens, e.g., mobile phones
    } else if (MediaQuery.of(context).size.width < 900) {
      return 2; // Medium screens, e.g., tablets
    } else if (MediaQuery.of(context).size.width < 1200) {
      return 3; // Large screens, e.g., laptops
    } else {
      return 4; // Extra-large screens, e.g., desktops
    }
  }

  double calculateAspectRatio(double height, int by, int remove) {
    return ((MediaQuery.of(context).size.width / by) - remove) / height;
  }

  double _aspectRatio(BuildContext context) {
    if (MediaQuery.of(context).size.width < 560) {
      return calculateAspectRatio(
          560, 1, 10); // Small screens, e.g., mobile phones
    } else if (MediaQuery.of(context).size.width < 600) {
      return calculateAspectRatio(
          700, 1, 30); // Small screens, e.g., bigger mobile phones
    } else if (MediaQuery.of(context).size.width < 900) {
      return calculateAspectRatio(680, 2, 30); // Medium screens, e.g., tablets
    } else if (MediaQuery.of(context).size.width < 1200) {
      return calculateAspectRatio(600, 3, 20); // Large screens, e.g., laptops
    } else {
      return calculateAspectRatio(
          600, 4, 20); // Extra-large screens, e.g., desktops
    }
  }

  @override
  void initState() {
    fetchData();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >= 400 && _showBackToTopButton == false) {
          setState(() {
            _showBackToTopButton = true;
          });
        } else if (!(_scrollController.offset >= 400) &&
            _showBackToTopButton == true) {
          setState(() {
            _showBackToTopButton = false;
          });
        }
      });

    super.initState();
  }

  fetchData() async {
    try {
      categoriesData = await fetchCategories();
      productsData = await fetchProducts();

      todayProduct = productsData;
      trendingProduct = productsData;
      recommendedProduct = productsData;

      trendingProduct.shuffle();
      recommendedProduct.shuffle();
    } catch (e) {
      errrorMessage = "Please check your internet and refresh";
    }

    setState(() {
      isLoading = false;
    });
  }

  List<Product> productsData = [];
  List<Category> categoriesData = [];
  List<Product> trendingProduct = [];
  List<Product> todayProduct = [];
  List<Product> recommendedProduct = [];

  String productPopId = '';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: kTransparentColor,
      backgroundColor: kPrimaryColor,
      // ignore: prefer_const_constructors
      appBar: MyAppbar(hideSearch: false),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: kAccentColor,
              ),
            )
          : errrorMessage.isNotEmpty
              ? Center(
                  child: Text(errrorMessage),
                )
              : SafeArea(
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: ListView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            CarouselSlider(
                              disableGesture: true,
                              carouselController: buttonCarouselController,
                              options: CarouselOptions(
                                autoPlay: true,
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                height: media.width > 1000
                                    ? media.height
                                    : media.width > 600
                                        ? media.width * 0.70
                                        : media.width * 0.90,
                                viewportFraction: 1.0,
                                padEnds: false,
                              ),
                              items: [
                                MyHero(
                                  image:
                                      'assets/frontend/assets/hero/hero1.jpg',
                                  text1: 'Shop smarter and happier',
                                  text2:
                                      'Say goodbye to the hassle of shopping',
                                  buttonCarouselController:
                                      buttonCarouselController,
                                ),
                                MyHero(
                                  image:
                                      'assets/frontend/assets/hero/hero2.jpg',
                                  text1: 'Seamless Shopping and Delivery',
                                  text2: 'real-time tracking and fast delivery',
                                  buttonCarouselController:
                                      buttonCarouselController,
                                ),
                                MyHero(
                                  image:
                                      'assets/frontend/assets/hero/hero3.jpg',
                                  text1: 'Our Logistics at Your Service!',
                                  text2: 'Get your packages at your doorstep',
                                  buttonCarouselController:
                                      buttonCarouselController,
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      breakPoint(media.width, 25, 100, 100),
                                  vertical: 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const EndToEndRow(
                                    widget1: MyFancyText(text: 'Categories'),
                                    widget2: MyOutlinedButton(
                                        navigate: CategoriesPage()),
                                  ),
                                  kSizedBox,
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      pageSnapping: false,
                                      scrollPhysics:
                                          const BouncingScrollPhysics(),
                                      aspectRatio: breakPoint(
                                          media.width, 16 / 9, 3.5, 5.4),
                                      viewportFraction: breakPoint(
                                          media.width, 1 / 2, 1 / 5, 1 / 7),
                                      padEnds: false,
                                    ),
                                    items: categoriesData
                                        .map(
                                          (item) => MyClickable(
                                            navigate: CategoryPage(
                                              activeCategory: item,
                                            ),
                                            child: MyCicleCard(
                                              image: item.image,
                                              text: item.name,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  kSizedBox,
                                  const EndToEndRow(
                                    widget1: MyFancyText(text: 'Trending'),
                                    widget2: MyOutlinedButton(
                                        navigate: CategoriesPage()),
                                  ),
                                  kSizedBox,
                                  GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _crossAxisCount(context),
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      childAspectRatio: _aspectRatio(context),
                                    ),
                                    itemCount: trendingProduct.length,
                                    shrinkWrap: true,
                                    // Specify the number of columns in the grid
                                    itemBuilder: (context, index) => MyCard(
                                      refresh: () {
                                        setState(() {});
                                      },
                                      product: trendingProduct[index],
                                      navigateCategory: CategoryPage(
                                        activeSubCategory:
                                            trendingProduct[index]
                                                .subCategoryId,
                                        activeCategory: trendingProduct[index]
                                            .subCategoryId
                                            .category,
                                      ),
                                      navigate: ProductPage(
                                          product: trendingProduct[index]),
                                      action: () {
                                        showMyDialog(
                                            context, trendingProduct[index]);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AspectRatio(
                              aspectRatio: 5,
                              child: Image.asset(
                                'assets/frontend/assets/banner/Benji-banner1.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            kSizedBox,
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal:
                                    breakPoint(media.width, 25, 100, 100),
                              ),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: EndToEndRow(
                                      widget1:
                                          MyFancyText(text: 'Today\'s Special'),
                                      widget2: MyOutlinedButton(
                                          navigate: CategoriesPage()),
                                    ),
                                  ),
                                  kSizedBox,
                                  GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _crossAxisCount(context),
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      childAspectRatio: _aspectRatio(context),
                                    ),
                                    itemCount: todayProduct.length,
                                    shrinkWrap: true,
                                    // Specify the number of columns in the grid
                                    itemBuilder: (context, index) => MyCard(
                                      refresh: () {
                                        setState(() {});
                                      },
                                      product: todayProduct[index],
                                      navigateCategory: CategoryPage(
                                        activeSubCategory:
                                            todayProduct[index].subCategoryId,
                                        activeCategory: todayProduct[index]
                                            .subCategoryId
                                            .category,
                                      ),
                                      navigate: ProductPage(
                                          product: todayProduct[index]),
                                      action: () {
                                        showMyDialog(
                                            context, todayProduct[index]);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            kSizedBox,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  // autoPlay: true,
                                  height: MediaQuery.of(context).size.width *
                                      breakPoint(media.width, 0.5, 0.44, 0.24),
                                  viewportFraction:
                                      breakPoint(media.width, 0.5, 0.5, 1 / 4),
                                  padEnds: false,
                                ),
                                items: const [
                                  MyImageCard(
                                    image:
                                        'assets/frontend/assets/mid_paragraph/banner1.jpg',
                                  ),
                                  MyImageCard(
                                      image:
                                          'assets/frontend/assets/mid_paragraph/banner2.jpg'),
                                  MyImageCard(
                                      image:
                                          'assets/frontend/assets/mid_paragraph/banner3.jpg'),
                                  MyImageCard(
                                      image:
                                          'assets/frontend/assets/mid_paragraph/banner4.jpg'),
                                ],
                              ),
                            ),
                            kSizedBox,
                            kSizedBox,
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal:
                                    breakPoint(media.width, 25, 100, 100),
                              ),
                              child: Column(
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: EndToEndRow(
                                        widget1:
                                            MyFancyText(text: 'Recommended'),
                                        widget2: MyOutlinedButton(
                                            navigate: CategoriesPage()),
                                      )),
                                  kSizedBox,
                                  GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _crossAxisCount(context),
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      childAspectRatio: _aspectRatio(context),
                                    ),
                                    itemCount: recommendedProduct.length,
                                    shrinkWrap: true,
                                    // Specify the number of columns in the grid
                                    itemBuilder: (context, index) => MyCard(
                                      refresh: () {
                                        setState(() {});
                                      },
                                      product: recommendedProduct[index],
                                      navigateCategory: CategoryPage(
                                        activeSubCategory:
                                            recommendedProduct[index]
                                                .subCategoryId,
                                        activeCategory:
                                            recommendedProduct[index]
                                                .subCategoryId
                                                .category,
                                      ),
                                      navigate: ProductPage(
                                          product: recommendedProduct[index]),
                                      action: () {
                                        showMyDialog(
                                            context, recommendedProduct[index]);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            kSizedBox,
                            kSizedBox,
                            AspectRatio(
                              aspectRatio: 5,
                              child: Image.asset(
                                'assets/frontend/assets/banner/Benji-banner2.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: breakPoint(media.width, 25, 50, 50),
                                vertical: 60,
                              ),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/frontend/assets/paragraph_bg/mobile_app_bg.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: LayoutGrid(
                                columnSizes: breakPointDynamic(
                                    media.width, [1.fr], [1.fr], [1.fr, 1.fr]),
                                rowSizes: const [auto, auto],
                                // rowGap: 40,
                                // columnGap: 24,
                                children: [
                                  SizedBox(
                                    child: Image.asset(
                                      'assets/frontend/assets/device/mobile_app_1.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        deviceType(media.width) > 2
                                            ? const SizedBox(
                                                height: kDefaultPadding * 2,
                                              )
                                            : kHalfSizedBox,
                                        const MyFancyText(
                                            text: 'Ecommerce and courier App'),
                                        kSizedBox,
                                        kSizedBox,
                                        const Text(
                                          'Experience the seamless Shopping, Secure and efficient Delivery - Our Logistics at Your Service!.',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black54),
                                        ),
                                        kSizedBox,
                                        kHalfSizedBox,
                                        fnd.kIsWeb || !Platform.isIOS
                                            ? Row(
                                                children: [
                                                  Container(
                                                    constraints:
                                                        BoxConstraints.loose(
                                                      const Size(100, 50),
                                                    ),
                                                    child: InkWell(
                                                      onTap:
                                                          launchDownloadLinkAndroid,
                                                      child: Image.asset(
                                                          'assets/frontend/assets/store/playstore.png'),
                                                    ),
                                                  ),
                                                  kWidthSizedBox,
                                                  Container(
                                                    constraints:
                                                        BoxConstraints.loose(
                                                      const Size(100, 30),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {},
                                                      child: Image.asset(
                                                          'assets/frontend/assets/store/appstore.png'),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        kSizedBox,
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal:
                                    breakPoint(media.width, 25, 120, 120),
                              ),
                              child: const Wrap(
                                spacing: 15,
                                runSpacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                children: [
                                  MyBorderCard(
                                    icon: Icons.speed,
                                    title: 'Fast Shopping',
                                    subtitle: 'Shop with easy',
                                  ),
                                  MyBorderCard(
                                    icon: Icons.pin_drop,
                                    title: 'Real-time Order Tracking',
                                    subtitle: 'Know where your package is at',
                                  ),
                                  MyBorderCard(
                                    icon: Icons.car_crash,
                                    title: 'Secure Shipping',
                                    subtitle: 'Your order is safe with us',
                                  ),
                                ],
                              ),
                            ),
                            kSizedBox,
                            kSizedBox,
                            const Footer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
      endDrawer: const MyDrawer(),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  minimumSize: const Size(45, 45),
                  foregroundColor: kAccentColor,
                  side: BorderSide(color: kAccentColor)),
              onPressed: _scrollToTop,
              child: const Icon(
                Icons.arrow_upward,
                size: 20,
              ),
            ),
    );
  }
}
