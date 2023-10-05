// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:flutter/material.dart';
import 'package:fancai_client/views/decorators/onboarding_page.dart';

class OnboardingPageViewModel {
  /// Title of page
  final String? title;

  /// Title of page
  final Widget? titleWidget;

  /// Text of page (description)
  final String? body;

  /// Widget content of page (description)
  final Widget? bodyWidget;

  /// Image of page
  /// Tips: Wrap your image with an alignment widget like Align or Center
  final Widget? image;

  /// Footer widget, you can add a button for example
  final Widget? footer;

  /// Page decoration
  /// Contain all page customizations, like page color, text styles
  final OnboardingPageDecoration decoration;

  /// If widget Order is reverse - body before image
  final bool reverse;

  /// Wrap content in scrollView
  final bool useScrollView;

  OnboardingPageViewModel({
    this.title,
    this.titleWidget,
    this.body,
    this.bodyWidget,
    this.image,
    this.footer,
    this.reverse = false,
    this.decoration = const OnboardingPageDecoration(),
    this.useScrollView = true,
  })  : assert(
          title != null || titleWidget != null,
          "You must provide either title (String) or titleWidget (Widget).",
        ),
        assert(
          (title == null) != (titleWidget == null),
          "You can not provide both title and titleWidget.",
        ),
        assert(
          body != null || bodyWidget != null,
          "You must provide either body (String) or bodyWidget (Widget).",
        ),
        assert(
          (body == null) != (bodyWidget == null),
          "You can not provide both body and bodyWidget.",
        );
}
