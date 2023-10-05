// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:flutter/material.dart';
import 'package:fancai_client/styles/scroll_to_bottom.dart';

class ScrollToBottom extends StatelessWidget {
  final Function? onScrollToBottomPress;
  final ScrollController scrollController;
  final bool inverted;
  final ScrollToBottomStyle scrollToBottomStyle;

  const ScrollToBottom({
    this.onScrollToBottomPress,
    required this.scrollController,
    required this.inverted,
    required this.scrollToBottomStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scrollToBottomStyle.width,
      height: scrollToBottomStyle.height,
      child: RawMaterialButton(
        elevation: 5,
        fillColor: scrollToBottomStyle.backgroundColor ??
            Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: Icon(
          scrollToBottomStyle.icon ?? Icons.keyboard_arrow_down,
          color: scrollToBottomStyle.textColor ?? Colors.white,
        ),
        onPressed: () {
          onScrollToBottomPress?.call() ??
              scrollController.animateTo(
                inverted
                    ? 0.0
                    : scrollController.position.maxScrollExtent + 25.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
        },
      ),
    );
  }
}
