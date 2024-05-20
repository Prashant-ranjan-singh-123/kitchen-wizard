import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:recipie_app/shared/saved_color.dart';

import '../presentation/shimmer/ShimmerConfig.dart';

Widget home_and_save_Shimmer() {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: 5,
    itemBuilder: (BuildContext context, int index) {
      String title = 'Chinese bale';
      int id = 2030;
      String subtitle = 'Ancient tradition, diverse, rich aroma, deep cultural significance, health benefits, millennia-old heritage, enjoyment of life.';
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                    color: HexColor(SavedColor.background),
                    width: 2
                ),
                boxShadow: [
                  BoxShadow(
                      color: HexColor(SavedColor.background),
                      blurRadius: 10
                  )
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    shimmer(
                      child: const AspectRatio(
                        aspectRatio: 20 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)
                          ),
                          child: SizedBox(),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 20/9,
                      child: shimmer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(1.00, 0.00),
                              end: const Alignment(-1, 0),
                              colors: [
                                HexColor(SavedColor.background).withOpacity(0.5),
                                const Color(0x00262626),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 20/9,
                      child: shimmer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(-1.00, 0.00),
                              colors: [
                                HexColor(SavedColor.background).withOpacity(0.5),
                                const Color(0x00262626),
                              ],
                              end: const Alignment(1, 0),
                            ),
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
                            child: shimmer(
                              child: AutoSizeText(title,
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 45,
                                    color: HexColor(SavedColor.fontColor)),
                              ),
                            ),
                          ),
                          shimmer(
                            child: AutoSizeText(subtitle,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25,
                                  color: HexColor(SavedColor.fontColor)),
                            ),
                          ),
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
          ),
          const SizedBox(height: 30,)
        ],
      );
    },
  );
}