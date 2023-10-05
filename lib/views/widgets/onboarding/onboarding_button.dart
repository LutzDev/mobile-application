// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? color;

  const OnboardingButton({Key? key, this.onPressed, this.child, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child ?? SizedBox(),
      style: TextButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
