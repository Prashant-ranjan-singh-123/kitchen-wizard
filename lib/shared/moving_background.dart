import 'package:flutter/material.dart';
import 'package:flutter_moving_background/enums/animation_types.dart';
import 'package:flutter_moving_background/flutter_moving_background.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipie_app/shared/saved_color.dart';

Widget CustomMovingBackground({
  required Widget child
}){
  return MovingBackground(
    animationType: AnimationType.rain,
    // duration: const Duration(seconds: 5),
    backgroundColor: HexColor(SavedColor.background),
    // backgroundColor: Colors.yellow.withOpacity(1),
    // duration: Duration(seconds: 3),
    circles: [
      MovingCircle(color: Colors.purple.withOpacity(0.5), radius: 250,blurSigma: 60,),
      MovingCircle(color: Colors.white.withOpacity(0.5), radius: 250,blurSigma: 60,),
      MovingCircle(color: Colors.deepOrange.withOpacity(0.5), radius: 250,blurSigma: 60,),
      MovingCircle(color: Colors.pink.withOpacity(0.5), radius: 250,blurSigma: 60,),
      MovingCircle(color: Colors.lightGreen.withOpacity(0.5), radius: 250,blurSigma: 60,),
      MovingCircle(color: HexColor('#25CAFF').withOpacity(0.5), radius: 250,blurSigma: 60,),
    ],
    child: child,
  );
}