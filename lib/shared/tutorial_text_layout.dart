import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TutorialText{

  static Widget headingBody({
    required String heading,
    required String body,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: AutoSizeText(
            maxLines: 1,
            heading,
            style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w800,
                fontSize: 40,
                color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            textAlign: TextAlign.center,
            body,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'Oswald'),
          ),
        ),
      ],
    );
  }
}