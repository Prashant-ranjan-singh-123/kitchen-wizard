import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipie_app/presentation/saved_page.dart';
import 'package:recipie_app/shared/saved_color.dart';
import 'home_page.dart';

class BottomNavBarMain extends StatefulWidget {
  int surPage;
  BottomNavBarMain({Key? key, required this.surPage});

  @override
  State<BottomNavBarMain> createState() => _BottomNavBarMainState();
}

class _BottomNavBarMainState extends State<BottomNavBarMain> {
  int currentIndex = 0;
  late PageController pageController;
  List<Widget> pages = [
    const HomePage(),
    const SavedPage(),
    // LinuxInstallation()
  ];
  IconData iconDataWindows = Icons.fastfood;
  IconData iconDataMac = Icons.bookmark;


  @override
  void initState() {
    currentIndex=widget.surPage;
    super.initState();
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: pages,
        ),
        bottomNavigationBar: Container(
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: GNav(
              backgroundColor: Colors.black87,
              color: HexColor(SavedColor.fontColor),
              activeColor: HexColor(SavedColor.fontColor),
              duration: const Duration(milliseconds: 400),
              gap: 8,
              padding: const EdgeInsets.only(right: 10, left: 10, top: 15, bottom: 15),
              hoverColor: HexColor(SavedColor.lightBackgrondShade),
              tabBackgroundColor: HexColor(SavedColor.red),
              tabBorderRadius: 10,
              curve: Curves.easeInOutCirc,
              selectedIndex: currentIndex,
              onTabChange: (index) {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 5),
                  curve: Curves.easeInOutCirc,
                );
              },
              tabs: [
                GButton(icon: iconDataWindows, text: 'Search'),
                GButton(icon: iconDataMac, text: 'Saved'),
                // GButton(icon: Icons.laptop_windows_sharp, text: 'Linux'),
              ],
            ),
          ),
        ),
      );
  }
}
