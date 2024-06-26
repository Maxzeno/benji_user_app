import 'package:benji/app/packages/packages_draft.dart';
import 'package:benji/app/packages/send_package.dart';
import 'package:benji/src/components/appbar/my_appbar.dart';
import 'package:benji/src/frontend/utils/constant.dart';
import 'package:benji/src/providers/my_liquid_refresh.dart';
import 'package:benji/src/repo/models/package/delivery_item.dart';
import 'package:benji/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/components/others/empty.dart';
import '../../src/providers/constants.dart';
import 'view_package.dart';

class Packages extends StatefulWidget {
  const Packages({super.key});

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages>
    with SingleTickerProviderStateMixin {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    pending = getDataPending();
    dispatched = getDataDispatched();
    completed = getDataCompleted();
    tabBarController = TabController(length: 3, vsync: this);
    scrollController.addListener(scrollListener);
  }

  late Future<List<DeliveryItem>> pending;
  late Future<List<DeliveryItem>> dispatched;
  late Future<List<DeliveryItem>> completed;
  @override
  void dispose() {
    scrollController.dispose();
    tabBarController.dispose();
    super.dispose();
  }

  bool isScrollToTopBtnVisible = false;
  bool refreshing = false;

//================================================= CONTROLLERS ===================================================\\
  late TabController tabBarController;
  final scrollController = ScrollController();
//================================================= FUNCTIONS ===================================================\\

  Future<List<DeliveryItem>> getDataPending() async {
    List<DeliveryItem> pending =
        await getDeliveryItemsByClientAndStatus('pending');
    return pending;
  }

  Future<List<DeliveryItem>> getDataDispatched() async {
    List<DeliveryItem> dispatched =
        await getDeliveryItemsByClientAndStatus('dispatched');
    return dispatched;
  }

  Future<List<DeliveryItem>> getDataCompleted() async {
    List<DeliveryItem> completed =
        await getDeliveryItemsByClientAndStatus('completed');
    return completed;
  }

  Future<void> handleRefresh() async {
    setState(() {
      refreshing = true;
    });
    setState(() {
      pending = getDataPending();
      dispatched = getDataDispatched();
      completed = getDataCompleted();
    });
    await Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        refreshing = false;
      });
    });
  }

  int selectedtabbar = 0;
  void clickOnTabBarOption(value) async {
    setState(() {
      selectedtabbar = value;
    });
  }

  //===================== Scroll to Top ==========================\\
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
    if (scrollController.position.pixels >= 100 &&
        isScrollToTopBtnVisible != true) {
      setState(() {
        isScrollToTopBtnVisible = true;
      });
    }
    if (scrollController.position.pixels < 100 &&
        isScrollToTopBtnVisible == true) {
      setState(() {
        isScrollToTopBtnVisible = false;
      });
    }
  }

//================================================= Navigation ===================================================\\

  void viewPendingPackage(deliveryItem) => Get.to(
        () => ViewPackage(deliveryItem: deliveryItem),
        routeName: 'ViewPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.size,
      );
  void viewDispatchedPackage(deliveryItem) => Get.to(
        () => ViewPackage(deliveryItem: deliveryItem),
        routeName: 'ViewPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.size,
      );

  void viewDeliveredPackage(deliveryItem) => Get.to(
        () => ViewPackage(deliveryItem: deliveryItem),
        routeName: 'ViewPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.size,
      );

  void toSendPackageScreen() => Get.off(
        () => const SendPackage(),
        routeName: 'SendPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toPackagesDraft() => Get.to(
        () => const PackagesDraft(),
        routeName: 'PackagesDraft',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        popGesture: false,
        transition: Transition.rightToLeft,
      );
  //========================================================================\\

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MyLiquidRefresh(
      handleRefresh: handleRefresh,
      child: Scaffold(
        appBar: MyAppBar(
          title: "My Packages",
          elevation: 0,
          actions: [
            TextButton(
              onPressed: _toPackagesDraft,
              child: Text(
                'Draft packages',
                style: TextStyle(
                    color: kAccentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButton: isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: scrollToTop,
                mini: deviceType(media.width) > 2 ? false : true,
                backgroundColor: kAccentColor,
                foregroundColor: kPrimaryColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const FaIcon(FontAwesomeIcons.chevronUp, size: 18),
              )
            : const SizedBox(),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(kDefaultPadding),
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: TabBar(
                      controller: tabBarController,
                      onTap: (value) => clickOnTabBarOption(value),
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
                        Tab(text: "Pending"),
                        Tab(text: "Dispatched"),
                        Tab(text: "Delivered"),
                      ],
                    ),
                  ),
                ),
                kSizedBox,
                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: refreshing
                      ? Center(
                          child: CircularProgressIndicator(color: kAccentColor),
                        )
                      : selectedtabbar == 0
                          ? FutureBuilder(
                              future: pending,
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return SizedBox(
                                    width: media.width,
                                    child: Column(
                                      children: [
                                        snapshot.data!.isEmpty
                                            ? EmptyCard(
                                                emptyCardMessage:
                                                    "You don't have any packages yet",
                                                showButton: true,
                                                buttonTitle: "Send a package",
                                                onPressed: toSendPackageScreen,
                                              )
                                            : ListView.separated(
                                                reverse: true,
                                                separatorBuilder: (context,
                                                        index) =>
                                                    Divider(color: kGreyColor2),
                                                itemCount:
                                                    snapshot.data!.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemBuilder: (context, index) =>
                                                    ListTile(
                                                  onTap: () =>
                                                      viewPendingPackage(
                                                          snapshot
                                                              .data![index]),
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  enableFeedback: true,
                                                  dense: true,
                                                  leading: FaIcon(
                                                    FontAwesomeIcons
                                                        .boxesStacked,
                                                    color: kAccentColor,
                                                  ),
                                                  title: Text(
                                                    snapshot
                                                        .data![index].itemName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      color: kTextBlackColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  subtitle: Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                            text:
                                                                "Delivery fee:"),
                                                        const TextSpan(
                                                            text: " "),
                                                        TextSpan(
                                                          text:
                                                              "₦${doubleFormattedText(snapshot.data![index].deliveryFee)}",
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFamily: 'sen',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  trailing: FaIcon(
                                                    FontAwesomeIcons
                                                        .hourglassHalf,
                                                    color: kLoadingColor,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                      ],
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
                          : selectedtabbar == 1
                              ? FutureBuilder(
                                  future: dispatched,
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return SizedBox(
                                        width: media.width,
                                        child: Column(
                                          children: [
                                            snapshot.data!.isEmpty
                                                ? const EmptyCard(
                                                    emptyCardMessage:
                                                        "You don't have any dispatched packages yet",
                                                  )
                                                : ListView.separated(
                                                    reverse: true,
                                                    separatorBuilder: (context,
                                                            index) =>
                                                        Divider(
                                                            color: kGreyColor2),
                                                    itemCount:
                                                        snapshot.data!.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) =>
                                                            ListTile(
                                                      onTap: () =>
                                                          viewDispatchedPackage(
                                                              (snapshot.data![
                                                                  index])),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      enableFeedback: true,
                                                      dense: true,
                                                      leading: FaIcon(
                                                        FontAwesomeIcons
                                                            .boxesStacked,
                                                        color: kAccentColor,
                                                      ),
                                                      title: Text(
                                                        snapshot.data![index]
                                                            .itemName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          color:
                                                              kTextBlackColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      subtitle: Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            const TextSpan(
                                                                text:
                                                                    "Delivery fee:"),
                                                            const TextSpan(
                                                                text: " "),
                                                            TextSpan(
                                                              text:
                                                                  "₦${doubleFormattedText(snapshot.data![index].deliveryFee)}",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontFamily:
                                                                    'sen',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: FaIcon(
                                                        FontAwesomeIcons
                                                            .bicycle,
                                                        color: kSecondaryColor,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                          ],
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
                                  future: completed,
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return SizedBox(
                                        width: media.width,
                                        child: Column(
                                          children: [
                                            snapshot.data!.isEmpty
                                                ? const EmptyCard(
                                                    emptyCardMessage:
                                                        "You don't have any delivered packages yet",
                                                  )
                                                : ListView.separated(
                                                    reverse: true,
                                                    separatorBuilder: (context,
                                                            index) =>
                                                        Divider(
                                                            color: kGreyColor2),
                                                    itemCount:
                                                        snapshot.data!.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) =>
                                                            ListTile(
                                                      onTap: () =>
                                                          viewDeliveredPackage(
                                                              (snapshot.data![
                                                                  index])),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      enableFeedback: true,
                                                      dense: true,
                                                      leading: FaIcon(
                                                        FontAwesomeIcons
                                                            .boxesStacked,
                                                        color: kAccentColor,
                                                      ),
                                                      title: Text(
                                                        snapshot.data![index]
                                                            .itemName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          color:
                                                              kTextBlackColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      subtitle: Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            const TextSpan(
                                                                text:
                                                                    "Delivery fee:"),
                                                            const TextSpan(
                                                                text: " "),
                                                            TextSpan(
                                                              text:
                                                                  "₦${doubleFormattedText(snapshot.data![index].deliveryFee)}",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontFamily:
                                                                    'sen',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: const FaIcon(
                                                        FontAwesomeIcons
                                                            .solidCircleCheck,
                                                        color: kSuccessColor,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      );
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: kAccentColor,
                                      ),
                                    );
                                  },
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
