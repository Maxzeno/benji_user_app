import 'dart:math';

import 'package:benji/src/repo/controller/address_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedbutton.dart';
import '../../src/components/others/empty.dart';
import '../../src/providers/constants.dart';
import '../../src/repo/models/address/address_model.dart';
import '../../src/repo/utils/helpers.dart';
import '../../theme/colors.dart';
import 'add_new_address.dart';
import 'edit_address_details.dart';

class Addresses extends StatefulWidget {
  const Addresses({super.key});

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  //==================================================== INITIAL STATE ======================================================\\
  @override
  void initState() {
    super.initState();
    checkAuth(context);
    checkIfShoppingLocation(context);
  }

  //============================================================ ALL VARIABLES ===================================================================\\

  //============================================================ BOOL VALUES ===================================================================\\

  //==================================================== CONTROLLERS ======================================================\\
  final ScrollController _scrollController = ScrollController();

  //================================================= Logic ===================================================\\

  //=================================================================================================\\

  //================================================================== FUNCTIONS ====================================================================\\

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {}

  //========================================================================\\

  //======================================= Navigation ==========================================\\

  void _pickOption(Address address) => Get.defaultDialog(
        title: "What do you want to do?",
        titleStyle: const TextStyle(
          fontSize: 20,
          color: kTextBlackColor,
          fontWeight: FontWeight.w700,
        ),
        content: const SizedBox(height: 0),
        cancel: ElevatedButton(
          onPressed: () => _deleteAddress(address.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: kAccentColor),
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: kBlackColor.withOpacity(0.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.solidTrashCan, color: kAccentColor),
              kHalfWidthSizedBox,
              Text(
                "Delete",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kAccentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        confirm: ElevatedButton(
          onPressed: () => _toEditAddressDetails(address),
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentColor,
            elevation: 10.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            shadowColor: kBlackColor.withOpacity(0.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.solidPenToSquare, color: kPrimaryColor),
              kHalfSizedBox,
              Text(
                "Edit",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );

  void _deleteAddress(String addressId) async {
    await deleteAddress(addressId);
    Get.back();
    await AddressController.instance.refreshData();
  }

  void _toEditAddressDetails(Address address) async {
    await Get.off(
      () => EditAddressDetails(address: address),
      routeName: 'EditAddressDetails',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    AddressController.instance.getAdresses();
    AddressController.instance.getCurrentAddress();
  }

  void _toAddNewAddress() async {
    await Get.to(
      () => const AddNewAddress(),
      routeName: 'AddNewAddress',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    AddressController.instance.getAdresses();
    AddressController.instance.getCurrentAddress();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      edgeOffset: 0,
      displacement: kDefaultPadding,
      semanticsLabel: "Pull to refresh",
      strokeWidth: 4,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          elevation: 0.0,
          title: "Addresses",
          backgroundColor: kPrimaryColor,
          actions: const [],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: MyElevatedButton(
            title: "Add new address",
            onPressed: _toAddNewAddress,
          ),
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: GetBuilder<AddressController>(initState: (state) {
            AddressController.instance.getAdresses();
            AddressController.instance.getCurrentAddress();
          }, builder: (controller) {
            if (controller.isLoad.value && controller.addresses.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  color: kAccentColor,
                ),
              );
            }
            return Scrollbar(
              controller: _scrollController,
              radius: const Radius.circular(10),
              scrollbarOrientation: ScrollbarOrientation.right,
              child: controller.addresses.isEmpty
                  ? const EmptyCard(
                      showButton: false,
                      emptyCardMessage: "You haven't added an address")
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: controller.addresses.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                            vertical: kDefaultPadding / 2,
                          ),
                          child: ListTile(
                            onTap: () =>
                                _pickOption(controller.addresses[index]),
                            enableFeedback: true,
                            trailing: FaIcon(
                              FontAwesomeIcons.chevronRight,
                              size: 16,
                              color: kAccentColor,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: min(
                                      media.width - 150,
                                      15.0 *
                                          controller
                                              .addresses[index].title.length),
                                  child: Text(
                                    controller.addresses[index].title
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                kWidthSizedBox,
                                controller.current.value.id ==
                                        controller.addresses[index].id
                                    ? Container(
                                        width: 65,
                                        height: 24,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: kAccentColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Default',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(
                                top: kDefaultPadding / 2,
                              ),
                              child: Text(
                                controller.addresses[index].details,
                                style: TextStyle(
                                  color: kTextGreyColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            );
          }),
        ),
      ),
    );
  }
}
