import 'package:flutter/material.dart';
import 'package:recipie_app/shared/tutorial_text_layout.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeScreenTutorialData{
  static List<TargetFocus> addTutorialData(GlobalKey k1, GlobalKey k2, GlobalKey k3, GlobalKey k4) {
    List<TargetFocus> focus = [];
    focus.addAll([
      TargetFocus(
        keyTarget: k1,
        alignSkip: Alignment.topRight,
        color: Colors.black,
        radius: 5,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return TutorialText.headingBody(
                  heading: "Ingredient Inventory",
                  body:
                  "In this space, you can enter the ingredients you currently possess.");
            },
          ),
        ],
      ),
      TargetFocus(
          keyTarget: k2,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                builder: (context, con) {
                  return TutorialText.headingBody(
                      heading: 'Add Button (+)',
                      body:
                      'Press this button to add ingredients to your list. We\'ll provide suggestions on what to make using those ingredients.');
                })
          ]),
      TargetFocus(
          keyTarget: k3,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                builder: (_, con) {
                  return TutorialText.headingBody(
                      heading: 'Find Matching Dishes',
                      body:
                      'This button will search for dishes you can make using the ingredients you provided earlier.');
                })
          ]),
      TargetFocus(
          keyTarget: k4,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                builder: (_, con) {
                  return TutorialText.headingBody(
                      heading: 'Available Dishes',
                      body:
                      'Here you can view all the dishes you can make with the provided ingredients.');
                })
          ])
    ]);
    return focus;
  }
}