// ignore_for_file: camel_case_types

import 'package:alpha_logistics/providers/constants.dart';
import 'package:flutter/material.dart';

import '../modules/onboarding screens.dart';
import '../screens/login.dart';
import '../theme/colors.dart';

class OnboardingScreen extends StatefulWidget {
  static String routeName = "Onboarding Screen";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        elevation: 0,
        actions: currentIndex % 3 == 2
            ? null
            : [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
        ),
        child: PageView.builder(
          itemCount: screens.length,
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (
            int index,
          ) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        screens[index].img,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: kDefaultPadding * 3,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    screens[index].text,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: kDefaultPadding * 1.5,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    screens[index].subtext,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: kDefaultPadding * 2,
                ),
                Container(
                  height: 10.0,
                  child: ListView.builder(
                    itemCount: screens.length,
                    shrinkWrap: false,
                    padding: EdgeInsets.only(
                      left: kDefaultPadding,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext, index) {
                      return Row(
                        children: [
                          AnimatedContainer(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3.0,
                            ),
                            width: currentIndex == index ? 32.0 : 17.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? kAccentColor
                                  : kPrimaryColor,
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                            ),
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: kDefaultPadding * 4,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (index == screens.length - 1) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    }
                    _pageController.nextPage(
                      duration: const Duration(
                        milliseconds: 600,
                      ),
                      curve: Curves.decelerate,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentColor,
                    maximumSize: Size(
                      354,
                      56,
                    ),
                    minimumSize: Size(
                      354,
                      56,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                    ),
                    elevation: 10,
                    shadowColor: kDarkGreyColor,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: currentIndex % 3 == 2 ? 0 : 10.0,
                      vertical: currentIndex % 3 == 2 ? 10.0 : 10.0,
                    ),
                    child: Text(
                      (index % 3 == 2 ? "Get Started" : "Next"),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
