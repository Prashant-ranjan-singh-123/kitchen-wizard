import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:recipie_app/data/shared%20pref/AppTutorial/home_screen_tutorial.dart';
import 'package:recipie_app/shared/moving_background.dart';
import 'package:lottie/lottie.dart';
import 'package:recipie_app/shared/tutorial_text_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../data/api_calling.dart';
import '../shared/item_list_showing_shimmer.dart';
import '../shared/saved_color.dart';
import 'expand_view.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  // for connectivity
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  bool isData = false;
  List<String> listOfIng = [];
  GlobalKey textKey = GlobalKey();
  GlobalKey noDataKey = GlobalKey();
  List<TargetFocus> focus = [];

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

  Future<void> startAnimCheck() async {
    if (await SavedScreenTurorialSharedPref().checkFirstRun()) {
      focus.addAll([
        TargetFocus(
            keyTarget: textKey,
            shape: ShapeLightFocus.RRect,
            color: Colors.black,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (_, index) {
                    return TutorialText.headingBody(
                        heading: 'Saved Area',
                        body:
                            'This area allows you to show your saved dishes.');
                  }),
            ]),
        TargetFocus(
            keyTarget: noDataKey,
            shape: ShapeLightFocus.RRect,
            color: Colors.black,
            contents: [
              TargetContent(
                  align: ContentAlign.bottom,
                  builder: (_, index) {
                    return TutorialText.headingBody(
                        heading: 'Saved Item List',
                        body:
                            'Here, you can access detailed information on all saved dishes. Click on each dish to view its details.');
                  }),
            ]),
      ]);
      startAnim();
    }
  }

  void startAnim() {
    Future.delayed(const Duration(seconds: 1, milliseconds: 900), () {
      TutorialCoachMark(
        targets: focus,
      ).show(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomMovingBackground(
      child: Scaffold(
        backgroundColor: HexColor(SavedColor.background).withOpacity(0.8),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Center(
                child: AutoSizeText(
                  'Saved Recipe',
                  key: textKey,
                  maxLines: 1,
                  style: const TextStyle(
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w800,
                      fontSize: 40,
                      color: Colors.white),
                ).animate().scale(duration: 350.ms, curve: Curves.decelerate),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.top + 20,
              ),
              Expanded(
                  child: list(context)
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getDataFill() async {
    SharedPreferences prefc = await SharedPreferences.getInstance();
    List<String> stringList12 = prefc.getStringList('numArray') ?? [];
    // print('IsDataxyx: $stringList12');
    if (stringList12.isNotEmpty) {
      var data = await ApiCalling().returnToSavedScreen(stringList12);
      print('IsDataxyx: $data');
      return data;
    }
    startAnimCheck();
    return [];
  }

  Widget list(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getDataFill(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return home_and_save_Shimmer();
        } else if (snapshot.hasError) {
          return noData(lottie: 'assets/lottie/error.json');
        } else if (snapshot.hasData) {
          List<Map<String, dynamic>> recipes = snapshot.data!;
          return isEmpty(recipes);
        } else {
          return noData(lottie: 'assets/lottie/error.json');
        }
      },
    );
  }

  Widget noData({required lottie}) {
    return Column(
      children: [
        const SizedBox(height: 40,),
        Card(
            color: Colors.transparent,
            elevation: 20,
            child: Lottie.asset(lottie))
            .animate()
            .scale(duration: 350.ms, curve: Curves.decelerate)
            .shake(duration: 600.ms, delay: 700.ms, hz: 2, rotation: 0.06),
      ],
    );
  }

  Widget isEmpty(List<Map<String, dynamic>> recipes){
    if(recipes.isEmpty){
      return noData(lottie: 'assets/lottie/noData.json');
    }else{
      return ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          final recipe = recipes[index];
          Image image = Image.network(recipe['image'], fit: BoxFit.cover,);
          String title = recipe['name'];
          int id = recipe['id'];
          String subtitle = recipe['summary'];
          return Column(
            children: [
              GestureDetector(
                onTap: (){
                  print('id is: $id');
                  Get.to(ExpandedFoodId(id: id, name: title, isSaved: true,));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: HexColor(SavedColor.red),
                          width: 2
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: HexColor(SavedColor.red),
                            blurRadius: 10
                        )
                      ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 20 / 9,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)
                              ),
                              child: SizedBox(
                                child: image,
                              ),
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 20/9,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: const Alignment(1.00, 0.00),
                                  end: const Alignment(-1, 0),
                                  colors: [
                                    HexColor(SavedColor.red).withOpacity(0.5),
                                    const Color(0x00262626),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 20/9,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: const Alignment(-1.00, 0.00),
                                  colors: [
                                    HexColor(SavedColor.red).withOpacity(0.5),
                                    const Color(0x00262626),
                                  ],
                                  end: const Alignment(1, 0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AspectRatio(
                        aspectRatio: 25/9,
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor(SavedColor.lightBackgrondShade),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: AutoSizeText(title,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 25,
                                        color: HexColor(SavedColor.fontColor)),
                                  ).animate()
                                      .scale(duration: 350.ms, curve: Curves.decelerate),
                                ),
                                AutoSizeText(subtitle,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 25,
                                      color: HexColor(SavedColor.fontColor)),
                                ).animate()
                                    .scale(duration: 350.ms, curve: Curves.decelerate),
                                const SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().scale(
                    duration: 350.ms, curve: Curves.decelerate),
              ),
              const SizedBox(height: 30,)
            ],
          );
        },
      );
    }
  }
}
