// ignore_for_file: use_build_context_synchronously

import 'package:benji/src/components/snackbar/my_floating_snackbar.dart';
import 'package:benji/src/repo/models/package/delivery_item.dart';
import 'package:benji/src/repo/services/api_url.dart';
import 'package:benji/src/repo/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

import '../../../src/providers/constants.dart';
import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedbutton.dart';
import '../../src/components/textformfield/message_textformfield.dart';
import '../../theme/colors.dart';

class ReportPackage extends StatefulWidget {
  final DeliveryItem package;
  const ReportPackage({super.key, required this.package});

  @override
  State<ReportPackage> createState() => _ReportPackageState();
}

class _ReportPackageState extends State<ReportPackage> {
  //============================================ ALL VARIABLES ===========================================\\

  //============================================ BOOL VALUES ===========================================\\
  bool _submittingReport = false;

  //============================================ CONTROLLERS ===========================================\\
  final TextEditingController _messageEC = TextEditingController();

  //============================================ FOCUS NODES ===========================================\\
  final FocusNode _messageFN = FocusNode();

  //============================================ KEYS ===========================================\\
  final GlobalKey<FormState> _formKey = GlobalKey();

  //============================================ FUNCTIONS ===========================================\\

  Future<void> _submitReport() async {
    setState(() {
      _submittingReport = true;
    });

    Map body = {};
    final url = Uri.parse(
        '$baseURL/clients/clientReportPackage/${widget.package.id}?message=${_messageEC.text}');
    print(url);
    final response =
        await http.post(url, body: body, headers: await authHeader());
    setState(() {
      _submittingReport = false;
    });
    if (response.statusCode == 200) {
      mySnackBar(
        context,
        kSuccessColor,
        "Success",
        "Report submitted successfully",
        const Duration(seconds: 1),
      );

      Get.back();
    } else {
      mySnackBar(
        context,
        kAccentColor,
        "Failed",
        "Report was not submitted",
        const Duration(seconds: 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(
          title: "Help and support",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
        ),
        bottomSheet: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          color: kPrimaryColor,
          padding: const EdgeInsets.only(
            top: kDefaultPadding,
            left: kDefaultPadding,
            right: kDefaultPadding,
            bottom: kDefaultPadding,
          ),
          child: MyElevatedButton(
            isLoading: _submittingReport,
            onPressed: (() async {
              if (_formKey.currentState!.validate()) {
                _submitReport();
              }
            }),
            title: "Submit",
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(child: SpinKitDoubleBounce(color: kAccentColor));
              }
              if (snapshot.connectionState == ConnectionState.none) {
                const Center(
                  child: Text("Please connect to the internet"),
                );
              }
              // if (snapshot.connectionState == snapshot.requireData) {
              //   SpinKitDoubleBounce(color: kAccentColor);
              // }
              if (snapshot.connectionState == snapshot.error) {
                const Center(
                  child: Text("Error, Please try again later"),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(kDefaultPadding),
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    width: 292,
                    child: Text(
                      'We will like to hear from you',
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  SizedBox(
                    width: 332,
                    child: Text(
                      "What went wrong with this package delivery?",
                      style: TextStyle(
                        color: kTextGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding * 2),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyMessageTextFormField(
                          controller: _messageEC,
                          textInputAction: TextInputAction.done,
                          focusNode: _messageFN,
                          hintText: "Enter your message here",
                          maxLines: 10,
                          keyboardType: TextInputType.text,
                          maxLength: 1000,
                          validator: (value) {
                            if (value == null || value == "") {
                              _messageFN.requestFocus();
                              return "Field cannot be left empty";
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
