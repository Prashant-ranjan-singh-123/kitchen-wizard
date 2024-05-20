import 'dart:async';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipie_app/data/api_calling.dart';
import 'package:recipie_app/data/shared%20pref/AppTutorial/home_screen_tutorial.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:recipie_app/presentation/tutorial/home_screen.dart';
import 'package:recipie_app/shared/moving_background.dart';
import 'package:recipie_app/shared/saved_color.dart';
import 'package:lottie/lottie.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:get/get.dart';
import '../shared/item_list_showing_shimmer.dart';
import 'bottom_nav_bar.dart';
import 'expand_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // for connectivity
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  TextEditingController con = TextEditingController();
  List<String> listOfIng = [];
  bool isResponse = false;
  List<TargetFocus> focus = [];

  // GlobalKey searchButtonButtonKey = GlobalKey();
  GlobalKey textAreaKey = GlobalKey();
  GlobalKey addButtonKey = GlobalKey();
  GlobalKey submitButtonKey = GlobalKey();
  GlobalKey resultButtonKey = GlobalKey();
  // GlobalKey savedButtonButtonKey = GlobalKey();

  void plusButtonAction() {
    String text = con.text.trim().toString();
    if (text.isNotEmpty) {
      listOfIng.add(text);
      con.clear();
    }else{
      con.clear();
    }
    setState(() {});
  }

  void searchButtonFun() {
    if(listOfIng.isNotEmpty) {
      setState(() {
        if(listOfIng.isEmpty) {
          isResponse = false;
        }else{
          isResponse = true;
        }
      });
    }
  }

  @override
  void initState() {
    startTutorial();
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
              Get.back();
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


  Future<void> startTutorial() async {
    if (await HomeScreenTurorialSharedPref().checkFirstRun()) {
      focus = HomeScreenTutorialData.addTutorialData(
          textAreaKey, addButtonKey, submitButtonKey, resultButtonKey);
      Future.delayed(const Duration(seconds: 1, milliseconds: 900), () {
        TutorialCoachMark(
          targets: focus,
          onFinish: () {
            Get.off(BottomNavBarMain(
              surPage: 1,
            ));
          },
        ).show(context: context);
      });
    }
  }

  Widget isEmpty(List<Map<String, dynamic>> recipes){
    if(recipes.isEmpty){
      return noData(lottie: 'assets/lottie/noData.json');
    }else{
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          final recipe = recipes[index];
          Image image = Image.network(recipe['image'], fit: BoxFit.cover,);
          String title = recipe['title'];
          int id = recipe['id'];
          String subtitle = recipe['description'];
          return Column(
            children: [
              GestureDetector(
                onTap: (){
                  print('id is: $id');
                  Get.to(ExpandedFoodId(id: id, name: title,));
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
                      // Text(subtitle,
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //     color: HexColor(SavedColor.fontColor),
                      //     fontSize: 17,
                      //     fontWeight: FontWeight.w600,
                      //     fontFamily: 'Oswald')),
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


  @override
  Widget build(BuildContext context) {
    return CustomMovingBackground(
      child: Scaffold(
          backgroundColor: HexColor(SavedColor.background).withOpacity(0.8),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).padding.top + 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AutoSizeText(
                      'Finding the best recipie',
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w800,
                          fontSize: 40,
                          color: Colors.white),
                    )
                        .animate()
                        .scale(duration: 350.ms, curve: Curves.decelerate),
                    const AutoSizeText(
                      'lets cook!',
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w800,
                          fontSize: 40,
                          color: Colors.white),
                    )
                        .animate()
                        .scale(duration: 350.ms, curve: Curves.decelerate),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Expanded(
                          key: textAreaKey,
                          child: TextField(
                            controller: con,
                            style: TextStyle(
                                color: HexColor(SavedColor.fontColor),
                                fontFamily: 'Oswald'),
                            decoration: InputDecoration(
                              labelText: 'Enter Ingredients',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontFamily: 'Oswald'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: BorderSide(
                                      color: HexColor(SavedColor.red))),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: HexColor(SavedColor.red)
                                        .withOpacity(0.7),
                                    width:
                                        1.5), // Border color when the TextField is not focused
                                borderRadius: BorderRadius.circular(2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: HexColor(SavedColor.red),
                                    width:
                                        3), // Border color when the TextField is focused
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            key: addButtonKey,
                            height: 65,
                            width: 65,
                            color: HexColor(SavedColor.red),
                            child: IconButton(
                              color: HexColor(SavedColor.fontColor),
                              onPressed: () {
                                plusButtonAction();
                              },
                              icon: const Icon(Icons.add),
                              iconSize: 40,
                            ))
                      ],
                    )
                        .animate()
                        .scale(duration: 400.ms, curve: Curves.decelerate)
                        .shake(
                            duration: 600.ms,
                            delay: 700.ms,
                            hz: 2,
                            rotation: 0.06),
                    const SizedBox(
                      height: 5,
                    ),
                    MaterialButton(
                      key: submitButtonKey,
                      color: HexColor(SavedColor.red),
                      onPressed: () {
                        searchButtonFun();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_sharp,
                              color: HexColor(SavedColor.fontColor),
                              size: 25,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Search',
                              style: TextStyle(
                                  color: HexColor(SavedColor.fontColor),
                                  fontFamily: 'Oswald',
                                  fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .scale(duration: 400.ms, curve: Curves.decelerate)
                        .shake(
                            duration: 600.ms,
                            delay: 820.ms,
                            hz: 2,
                            rotation: 0.06),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Wrap(
                        children: [
                          for (int i = 0; i < listOfIng.length; i++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Chip(
                                backgroundColor: Color((12 * 0xFFFFFF).toInt())
                                    .withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                                label: Text(listOfIng[i]), // Changed to index i
                                onDeleted: () {
                                  setState(() {
                                    listOfIng.removeAt(i);
                                  });
                                },
                                deleteIcon: const Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                                // Chip
                              ),
                              // Padding
                            ),
                          // for loop
                        ],
                        // children
                      ),
                      // Wrap
                    ),
                    Container(
                      key: resultButtonKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: const AutoSizeText(
                              'Results',
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 40,
                                  color: Colors.white),
                            ).animate().scale(
                                duration: 350.ms, curve: Curves.decelerate),
                          ),
                          // const SizedBox(
                          //   height: 80,
                          // ),
                          Center(
                            child: isResponse ? list(context) : noData(lottie: 'assets/lottie/noData.json'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
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

  // Widget list(BuildContext context){
  //   return ListView.builder(
  //     physics: NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     itemCount: 20,
  //     itemBuilder: (BuildContext context, int index) {
  //       final recipe = index;
  //       int id = 73420;
  //       Image image = Image.network('https://img.spoonacular.com/recipes/645479-556x370.jpg', fit: BoxFit.cover,);
  //       String title = 'Green Monster Ice Pops';
  //       String subtitle= 'Need a gluten free and dairy free dessert? Green Monster Ice Pops could be an amazing recipe to try....';
  //       return Column(
  //         children: [
  //           GestureDetector(
  //             onTap: (){
  //               Get.to(ExpandedFoodId(id: id,), transition: Transition.fadeIn, duration: 900.ms, curve: Curves.easeInCirc);
  //             },
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: const BorderRadius.all(Radius.circular(10)),
  //                 border: Border.all(
  //                   color: HexColor(SavedColor.red),
  //                   width: 2
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: HexColor(SavedColor.red),
  //                     blurRadius: 10
  //                   )
  //                 ]
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Stack(
  //                     children: [
  //                       AspectRatio(
  //                         aspectRatio: 20 / 9,
  //                         child: ClipRRect(
  //                           borderRadius: const BorderRadius.only(
  //                               topRight: Radius.circular(10),
  //                               topLeft: Radius.circular(10)
  //                           ),
  //                           child: SizedBox(
  //                             child: image,
  //                           ),
  //                         ),
  //                       ),
  //                       AspectRatio(
  //                         aspectRatio: 20/9,
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             gradient: LinearGradient(
  //                               begin: const Alignment(1.00, 0.00),
  //                               end: const Alignment(-1, 0),
  //                               colors: [
  //                                 HexColor(SavedColor.red).withOpacity(0.5),
  //                                 const Color(0x00262626),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       AspectRatio(
  //                         aspectRatio: 20/9,
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             gradient: LinearGradient(
  //                               begin: const Alignment(-1.00, 0.00),
  //                               colors: [
  //                                 HexColor(SavedColor.red).withOpacity(0.5),
  //                                 const Color(0x00262626),
  //                               ],
  //                               end: const Alignment(1, 0),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   AspectRatio(
  //                     aspectRatio: 25/9,
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                           color: HexColor(SavedColor.lightBackgrondShade),
  //                         borderRadius: const BorderRadius.only(
  //                           bottomRight: Radius.circular(10),
  //                           bottomLeft: Radius.circular(10),
  //                         )
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 20),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                           children: [
  //                             Center(
  //                               child: AutoSizeText(title,
  //                                 maxLines: 1,
  //                                 style: TextStyle(
  //                                     fontFamily: 'Oswald',
  //                                     fontWeight: FontWeight.w800,
  //                                     fontSize: 100,
  //                                     color: HexColor(SavedColor.fontColor)),
  //                               ).animate()
  //                                   .scale(duration: 350.ms, curve: Curves.decelerate),
  //                             ),
  //                             AutoSizeText(subtitle,
  //                               maxLines: 2,
  //                               style: TextStyle(
  //                                   fontFamily: 'Roboto',
  //                                   fontWeight: FontWeight.w800,
  //                                   fontSize: 25,
  //                                   color: HexColor(SavedColor.fontColor)),
  //                             ).animate()
  //                                 .scale(duration: 350.ms, curve: Curves.decelerate),
  //                             const SizedBox()
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   // Text(subtitle,
  //                   //     textAlign: TextAlign.center,
  //                   //     style: TextStyle(
  //                   //     color: HexColor(SavedColor.fontColor),
  //                   //     fontSize: 17,
  //                   //     fontWeight: FontWeight.w600,
  //                   //     fontFamily: 'Oswald')),
  //                 ],
  //               ),
  //             ).animate().scale(
  //                 duration: 350.ms, curve: Curves.decelerate),
  //           ),
  //           const SizedBox(height: 30,)
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget list(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ApiCalling().getHttp(listOfIng),
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
}
