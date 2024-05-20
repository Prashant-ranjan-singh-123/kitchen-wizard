import 'package:auto_size_text/auto_size_text.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recipie_app/shared/saved_color.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

import 'ShimmerConfig.dart';

class ShimmerExpandView extends StatelessWidget {
  const ShimmerExpandView({super.key});

  @override
  Widget build(BuildContext context) {
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
            shimmer(
              child: Container(
                width: size.width,
                height: (size.height / 2),
                color: Colors.black,
                child: const SizedBox(),
              ),
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
          child: shimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  shimmer(
                      child: const Text(
                        'Kitchen Wizard',
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            ),
                      ),
                    ),
                    Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50))),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite,
                            ))),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 120,
                  width: Get.width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
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
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              )),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  size: 50,
                                ),
                                Text(
                                  '200 cal',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
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
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
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
                                ), const Text(
                                  '30 Gm',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
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
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              )),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.monitor_weight_outlined,
                                  size: 50,
                                ),
                                Text(
                                  '70 Gm',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
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
                  child: const Column(
                    children: [
                      AutoSizeText(
                        'Cooking Instruction',
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Card(
                        elevation: 20,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(''''"Gento" is a song recorded by the Filipino boy band SB19 (pictured). It was written by the band's leader, Pablo, and produced along with his brother Joshua Daniel Nase and the record producer Simon Servida. The lyrics of the pop and hip hop track are themed around empowerment and use gold mining as a metaphor for achieving success. Sony Music Philippines released the song on May 19, 2023, as the lead single from the boy band's second extended play (EP), Pagtatag! (2023). The song won multiple awards, and critics praised its catchiness and lyricism. A dance challenge set to the song became a trend on TikTok. "Gento" achieved top-15 chart positions in the Philippines and on Billboard's World Digital Song Sales chart; SB19 became the first Filipino group to enter the chart. The band promoted the song with a music video depicting them mining for gold and with various live performances, including on their Pagtatag! World Tour.'''),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

