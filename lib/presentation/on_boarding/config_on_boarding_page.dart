import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:recipie_app/shared/saved_color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import '../bottom_nav_bar.dart';
import 'on_boarding_pages.dart';
import 'package:hexcolor/hexcolor.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isLast = false;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = PageController();

    List pages;
    pages = [
      OnboardingPage(
        title: 'Find Dishes',
        body:
            "This app serves as your ultimate cooking guide. "
            "Discover a wide variety of dishes by exploring our extensive collection of recipes. "
            "In addition, we'll save your favorite recipes for easy access.",
        lottie: 'assets/lottie/food.json',
        zoom: 1.2,
      ),
      OnboardingPage(
        title: 'Lets Get Started',
        body:
        "This isn't your ordinary recipe maker application. "
            "Here, we offer solutions based on the ingredients you have, showing you how to create delicious dishes using what you already have on hand.",
        lottie: 'assets/lottie/started.json',
        zoom: 1.2,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: PageView(
              onPageChanged: (int val) {
                if (val == 0) {
                  isLast = false;
                  isFirst = true;
                }
                if (val == 1) {
                  isLast = true;
                  isFirst = false;
                }
                if (val != 1 && val != 0) {
                  isLast = false;
                  isFirst = false;
                }
                setState(() {
                  isLast;
                  isFirst;
                });
              },
              controller: controller,
              children: List.generate(pages.length, (index) => pages[index]),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.96),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!isFirst)
                  InkWell(
                      onTap: () {
                        controller.previousPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      },
                      child: CircleAvatar(
                        backgroundColor: HexColor(SavedColor.red),
                        child: Icon(
                          Icons.navigate_before,
                          color: HexColor(SavedColor.fontColor),
                        ),
                      ))
                else
                  const CircleAvatar(
                    backgroundColor: Colors.transparent,
                  ),
                SmoothPageIndicator(
                  controller: controller,
                  count: 2,
                  effect: ScrollingDotsEffect(
                      dotColor: Colors.white,
                      activeDotColor: HexColor(SavedColor.red),
                      fixedCenter: true,
                      dotWidth: 5,
                      activeDotScale: 1.1,
                      dotHeight: 5),
                ),
                if (!isLast)
                  InkWell(
                      onTap: () {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      },
                      child: CircleAvatar(
                        backgroundColor: HexColor(SavedColor.red),
                        child: Icon(
                          Icons.navigate_next,
                          color: HexColor(SavedColor.fontColor),
                        ),
                      ))
                else
                  InkWell(
                      onTap: () {
                        Get.off(BottomNavBarMain(surPage: 0,),
                            transition: Transition.zoom,
                            duration: const Duration(milliseconds: 450));
                      },
                      child: CircleAvatar(
                        backgroundColor: HexColor(SavedColor.red),
                        child: Icon(
                          Icons.navigate_next,
                          color: HexColor(SavedColor.fontColor),
                        ),
                      ))
              ],
            ),
          )
              .animate(delay: 1000.ms)
              .scale(duration: 1400.ms, curve: Curves.decelerate),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: SvgPicture.asset(
          //     'assets/onboarding/wave.svg',
          //     color: Theme.of(context).colorScheme.primary,
          //     width: MediaQuery.of(context).size.width,
          //   ),
          // ),
        ],
      ),
    );
  }
}
