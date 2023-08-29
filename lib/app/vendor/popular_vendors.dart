import 'package:benji_user/src/providers/my_liquid_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/vendor/popular_vendors_card.dart';
import '../../src/providers/constants.dart';
import '../../src/repo/models/vendor/vendor.dart';
import '../../src/repo/utils/helpers.dart';
import '../../theme/colors.dart';

class PopularVendors extends StatefulWidget {
  const PopularVendors({super.key});

  @override
  State<PopularVendors> createState() => _PopularVendorsState();
}

class _PopularVendorsState extends State<PopularVendors> {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();

    _getData();
  }

  Map? _data;

  _getData() async {
    await checkAuth(context);
    List<VendorModel> vendor = await getVendors();
    setState(() {
      _data = {
        'vendor': vendor,
      };
    });
  }

  //==================================================== CONTROLLERS ======================================================\\
  final _scrollController = ScrollController();

  //==================================================== FUNCTIONS ===========================================================\\
  //===================== Handle refresh ==========================\\
  Future<void> _handleRefresh() async {
    setState(() {
      _data = null;
    });
    await _getData();
  }
  //========================================================================\\

  @override
  Widget build(BuildContext context) {
    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          elevation: 0.0,
          title: "Popular Vendors ",
          toolbarHeight: 80,
          backgroundColor: kPrimaryColor,
          actions: [],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: _data == null
              ? SpinKitChasingDots(color: kAccentColor)
              : Scrollbar(
                  controller: _scrollController,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  radius: Radius.circular(10),
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemCount: _data!['vendor'].length,
                    padding: const EdgeInsets.all(kDefaultPadding),
                    separatorBuilder: (context, index) => kHalfSizedBox,
                    itemBuilder: (BuildContext context, int index) =>
                        PopularVendorsCard(
                      onTap: () {},
                      cardImage: 'best-choice-restaurant.png',
                      vendorName: _data!['vendor'][index].shopName,
                      food: "Food",
                      rating: "3.6",
                      noOfUsersRated: "500",
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}