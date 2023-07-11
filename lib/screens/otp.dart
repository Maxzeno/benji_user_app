import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/constants.dart';
import '../reusable widgets/my appbar.dart';
import '../reusable widgets/my fixed snackBar.dart';
import '../reusable widgets/otp textFormField.dart';
import '../reusable widgets/reusable authentication first half.dart';
import '../theme/colors.dart';
import 'reset password.dart';

class SendOTP extends StatefulWidget {
  const SendOTP({super.key});

  @override
  State<SendOTP> createState() => _SendOTPState();
}

class _SendOTPState extends State<SendOTP> {
  //=========================== ALL VARIABBLES ====================================\\

  //=========================== CONTROLLERS ====================================\\

  TextEditingController pin1EC = TextEditingController();
  TextEditingController pin2EC = TextEditingController();
  TextEditingController pin3EC = TextEditingController();
  TextEditingController pin4EC = TextEditingController();

  //=========================== KEYS ====================================\\

  final _formKey = GlobalKey<FormState>();

  //=========================== FOCUS NODES ====================================\\
  FocusNode pin1FN = FocusNode();
  FocusNode pin2FN = FocusNode();
  FocusNode pin3FN = FocusNode();
  FocusNode pin4FN = FocusNode();

  //=========================== BOOL VALUES====================================\\
  bool isLoading = false;

  //=========================== FUNCTIONS ====================================\\
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    // Simulating a delay of 3 seconds
    await Future.delayed(Duration(seconds: 2));

    //Display snackBar
    myFixedSnackBar(
      context,
      "OTP Verified".toUpperCase(),
      kSuccessColor,
    );

    // Navigate to the new page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ResetPassword(),
      ),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: MyAppBar(
          title: "",
          elevation: 0.0,
          toolbarHeight: 80,
          actions: [],
          backgroundColor: kTransparentColor,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const ReusableAuthenticationFirstHalf(
                title: "Verification",
                subtitle:
                    "example@gmail.com\nWe have sent a code to your email",
                decoration: BoxDecoration(),
                imageContainerHeight: 0,
              ),
              kSizedBox,
              Expanded(
                child: Container(
                  width: media.size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: kDefaultPadding / 2,
                      top: kDefaultPadding,
                      right: kDefaultPadding,
                    ),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: kDefaultPadding,
                      ),
                      children: [
                        Container(
                          width: media.size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Code'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(
                                    0xFF31343D,
                                  ),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Resend",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: kTextBlackColor,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "in",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: kTextBlackColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "1:00",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: kTextBlackColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 90,
                                width: 68,
                                child: MyOTPTextFormField(
                                  textInputAction: TextInputAction.next,
                                  onSaved: (pin1) {
                                    pin1EC.text = pin1!;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      pin1FN.requestFocus();
                                      return "";
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 90,
                                width: 68,
                                child: MyOTPTextFormField(
                                  textInputAction: TextInputAction.next,
                                  onSaved: (pin2) {
                                    pin2EC.text = pin2!;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      pin2FN.requestFocus();
                                      return "";
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 90,
                                width: 70,
                                child: MyOTPTextFormField(
                                  textInputAction: TextInputAction.next,
                                  onSaved: (pin3) {
                                    pin3EC.text = pin3!;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      pin3FN.requestFocus();
                                      return "";
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 90,
                                width: 68,
                                child: MyOTPTextFormField(
                                  textInputAction: TextInputAction.next,
                                  onSaved: (pin4) {
                                    pin4EC.text = pin4!;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      pin4FN.requestFocus();
                                      return "";
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: kDefaultPadding * 4,
                        ),
                        isLoading
                            ? Center(
                                child: SpinKitChasingDots(
                                  color: kAccentColor,
                                  duration: const Duration(seconds: 2),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: (() async {
                                  if (_formKey.currentState!.validate()) {
                                    loadData();
                                  }
                                }),
                                style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: kAccentColor,
                                  fixedSize: Size(media.size.width, 50),
                                ),
                                child: Text(
                                  'Verify'.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
