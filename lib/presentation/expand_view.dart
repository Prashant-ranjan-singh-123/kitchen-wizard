import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:get/get.dart';
import 'package:recipie_app/data/api_calling.dart';
import 'package:recipie_app/presentation/shimmer/expand_shimmer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/shared pref/AppTutorial/home_screen_tutorial.dart';
import '../shared/saved_color.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter/animation.dart';
import '../shared/tutorial_text_layout.dart';
import 'bottom_nav_bar.dart';

class ExpandedFoodId extends StatefulWidget {
  int id;
  String name;
  bool isSaved;
  ExpandedFoodId({super.key, required this.id, required this.name, this.isSaved=false});

  @override
  State<ExpandedFoodId> createState() => _ExpandedFoodIdState();
}

class _ExpandedFoodIdState extends State<ExpandedFoodId> {
  // for connectivity
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  bool isFavClick = false;
  GlobalKey nameKey = GlobalKey();
  GlobalKey favKey = GlobalKey();
  GlobalKey ingridentsKey = GlobalKey();
  GlobalKey cookingKey = GlobalKey();
  List<TargetFocus> focus = [];
  late String _nameOfDish='';
  String _cal='';
  String _fat='';
  String _protein='';
  String _image='';
  String _summary_info='';
  String _cook_info='';
  bool isLoading=true;

  // Future<void> isFavourite() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> stringList1 = prefs.getStringList('numArray')??[];
  //
  //   if (stringList1.contains(widget.id)) {
  //     isFavClick = true;
  //   }else{
  //     isFavClick = false;
  //   }
  //   // setState(() {});
  // }

  Future<void> favourateButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? stringList1 = prefs.getStringList('numArray');
    isFavClick = !isFavClick; // Assuming isFavClick is a boolean variable to track button state

    if(widget.isSaved){
      if (stringList1 != null) {
        List<num> numArray = stringList1.map((string) => num.parse(string)).toList();
        if (numArray.contains(widget.id)) {
          numArray.remove(widget.id);
          await saveNumArray(numArray);
        }
      }
      Get.offAll(BottomNavBarMain(surPage: 1,));
      return;
    }

    if (isFavClick) {
      // Add to favorites
      if (stringList1 != null) {
        List<num> numArray = stringList1.map((string) => num.parse(string)).toList();
        if (!numArray.contains(widget.id)) {
          numArray.add(widget.id);
          await saveNumArray(numArray);
        }
      } else {
        // If numArray is null, create a new list with widget.id
        await saveNumArray([widget.id]);
      }
    } else {
      // Remove from favorites
      if (stringList1 != null) {
        List<num> numArray = stringList1.map((string) => num.parse(string)).toList();
        if (numArray.contains(widget.id)) {
          numArray.remove(widget.id);
          await saveNumArray(numArray);
        }
      }
    }

    // Fetch updated list from SharedPreferences
    List<String>? updatedList = prefs.getStringList('numArray');
    print('Shared Pref: $updatedList');

    setState(() {
      // Update UI if necessary
    });
  }

  Future<void> saveNumArray(List<num> numArray) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList = numArray.map((num) => num.toString()).toList();
    await prefs.setStringList('numArray', stringList);
  }


  Future<void> fetchData() async {
    Map<String, dynamic> map =
        await ApiCalling().getRecipeInformation(widget.id);
    // _nameOfDish = map['name'];
    _cal = map['calories'].toString();
    _fat = map['fat'].toString();
    _protein = map['protein'].toString();
    _image = map['image'].toString();
    _summary_info = map['summary'].toString();
    _cook_info = map['cookingInstruction'];


    if(await SavedScreenTurorialSharedPref().checkFirstRun()){
      focus.addAll([
        TargetFocus(
            keyTarget: nameKey,
            shape: ShapeLightFocus.RRect,
            color: Colors.black,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (_, index) {
                    return TutorialText.headingBody(
                        heading: 'Dish Name',
                        body:
                        'This is the name of the dish, which you are seeing.');
                  }),
            ]),
        TargetFocus(
            keyTarget: favKey,
            shape: ShapeLightFocus.RRect,
            color: Colors.black,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (_, index) {
                    return TutorialText.headingBody(
                        heading: 'Favourite',
                        body:
                        'By Clicking on this button you can add it in favourite list.');
                  }),
            ]),
        TargetFocus(
            keyTarget: ingridentsKey,
            shape: ShapeLightFocus.RRect,
            color: Colors.black,
            contents: [
              TargetContent(
                  align: ContentAlign.top,
                  builder: (_, index) {
                    return TutorialText.headingBody(
                        heading: 'Health Information',
                        body:
                        'Here, you can access information on this dishes, like Calories, Protein, etc');
                  }),
            ]),
        TargetFocus(
            keyTarget: cookingKey,
            shape: ShapeLightFocus.RRect,
            color: Colors.black,
            contents: [
              TargetContent(
                  align: ContentAlign.top,
                  builder: (_, index) {
                    return TutorialText.headingBody(
                        heading: 'Cooking Instruction',
                        body:
                        'Here, you can access detailed information on how to cook this dish. Read the instruction carefully and have a try');
                  }),
            ]),
      ]);
      start();
    }
  }

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  void showDialogBox() => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: HexColor(SavedColor.background),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200,
            child: Image.asset('assets/images/no_connection.png'),
          ),
          const SizedBox(height: 32),
          Text(
            "Whoops!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: HexColor(SavedColor.fontColor),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "No internet connection found.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: HexColor(SavedColor.fontColor),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Check your connection and try again.",
            style: TextStyle(fontSize: 12,
              color: HexColor(SavedColor.fontColor),),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text("Try Again", style: TextStyle(color: HexColor(SavedColor.fontColor),),),
            style: ElevatedButton.styleFrom(
                backgroundColor: HexColor(SavedColor.red),
                elevation: 20
            ),
            onPressed: () async {
              Navigator.pop(context);
              setState(() => isAlertSet = false);
              isDeviceConnected = await InternetConnectionChecker().hasConnection;
              if (!isDeviceConnected && !isAlertSet) {
                showDialogBox();
                setState(() => isAlertSet = true);
              }
            },
          ),
        ],
      ),
    ),
  );


  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }


  void start() {
    Future.delayed(1000.ms, () {
      TutorialCoachMark(
        targets: focus,
      ).show(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: ShimmerExpandView());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return _ui();
            }
          },
        );
  }

  Widget _ui() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: HexColor(SavedColor.background),
      bottomSheet: _bottomSheet(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.black,
            ),
            Container(
              width: size.width,
              height: (size.height / 2),
              child: Image.network(_image, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet(){
    return Container(
      width: Get.width,
      height: Get.height * 0.58,
      decoration: BoxDecoration(
          color: HexColor(SavedColor.background),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    key: nameKey,
                    widget.name,
                    maxLines: 2,
                    style: TextStyle(
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: HexColor(SavedColor.fontColor)),
                  ),
                  Container(
                    width: 50,
                      height: 50,
                      key: favKey,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.all(Radius.circular(50))),
                      child: IconButton(
                          onPressed: () {
                            favourateButton();
                          },

                          icon: widget.isSaved ? Icon(
                            Icons.bookmark,
                            color: HexColor(SavedColor.red),
                          ) : isFavClick
                              ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                              : Icon(
                            Icons.favorite,
                            color:
                            HexColor(SavedColor.background),
                          )
                      )
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                key: ingridentsKey,
                height: 120,
                width: Get.width,
                decoration: BoxDecoration(
                    color: HexColor(SavedColor.red).withOpacity(1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: HexColor(SavedColor.fontColor)
                                .withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                size: 50,
                              ),
                              AutoSizeText(
                                '$_cal cal',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: HexColor(SavedColor.fontColor)
                                .withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Icon(
                                MdiIcons.dumbbell,
                                size: 50,
                              ),
                              AutoSizeText(
                                '$_protein Gm',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: HexColor(SavedColor.fontColor)
                                .withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.monitor_weight_outlined,
                                size: 50,
                              ),
                              AutoSizeText(
                                '$_fat Gm',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                key: cookingKey,
                child: Column(
                  children: [
                    AutoSizeText(
                      'Summary',
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                          color: HexColor(SavedColor.fontColor)),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Card(
                      color: HexColor(SavedColor.fontColor),
                      elevation: 20,
                      shadowColor: HexColor(SavedColor.red),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HtmlWidget(_summary_info),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  AutoSizeText(
                    'Cooking Instruction',
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                        color: HexColor(SavedColor.fontColor)),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Card(
                    color: HexColor(SavedColor.fontColor),
                    elevation: 20,
                    shadowColor: HexColor(SavedColor.red),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: HtmlWidget(_cook_info),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
