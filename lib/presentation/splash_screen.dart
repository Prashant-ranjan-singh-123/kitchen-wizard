import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:recipie_app/shared/moving_background.dart';
import 'package:recipie_app/shared/saved_color.dart';
import '../data/shared pref/check_first_time.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2000), (){
      Get.off(const CheckFirstTime());
    });
    return CustomMovingBackground(
      child: Scaffold(
        backgroundColor: HexColor(SavedColor.background).withOpacity(0.8),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                  width: 130, height: 130, child: Image.asset('assets/images/icon.png', color: HexColor(SavedColor.red),)).animate()
                  .scale(duration: 350.ms, curve: Curves.decelerate)
                  .shake(duration: 600.ms, delay: 400.ms, hz: 2, rotation: 0.06),
            ),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AutoSizeText('Kitchen Wizard',
                maxLines: 1,
                style: TextStyle(
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w800,
                    fontSize: 40,
                    color: HexColor(SavedColor.fontColor)),
              ).animate()
                  .scale(duration: 350.ms, curve: Curves.decelerate),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: AutoSizeText('------Mastering the Art------',
                maxLines: 1,
                style: TextStyle(
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: HexColor(SavedColor.fontColor)),
              ).animate()
                  .scale(duration: 350.ms, curve: Curves.decelerate),
            ),
          ],
        ),
      ),
    );
  }
}
