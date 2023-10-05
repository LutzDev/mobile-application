import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

enum ScrollIntoViewOfItems { none, slow, fast }

const springFast = SpringDescription(mass: 1, stiffness: 200, damping: 30);

mixin CommonParams {
  late final Color? _headerBackgroundColor;
  late final double? _headerBorderRadius;
  late final EdgeInsets? _headerPadding;
  late final Widget? _leftIcon, _rightIcon;
  late final RxBool? _flipRightIconIfOpen = true.obs;
  late final Color? _contentBackgroundColor;
  late final Color? _contentBorderColor;
  late final double? _contentBorderWidth;
  late final double? _contentBorderRadius;
  late final double? _contentHorizontalPadding;
  late final double? _contentVerticalPadding;
  late final double? _paddingBetweenOpenSections;
  late final double? _paddingBetweenClosedSections;
  late final ScrollIntoViewOfItems? _scrollIntoViewOfItems;
}

class ListController extends GetxController {
  final controller = AutoScrollController(axis: Axis.vertical);
  final openSections = <UniqueKey>[].obs;

  /// Maximum number of open sections at any given time.
  /// Opening a new section will close the "oldest" open section
  int maxOpenSections = 1;

  /// The delay in milliseconds (when the entire accordion loads)
  /// before the individual sections open one after another.
  /// Helpful if you go to a new page in your app and then (after
  /// the delay) have a nice opening sequence.
  int initialOpeningSequenceDelay = 250;

  void updateSections(UniqueKey key) {
    openSections.contains(key)
        ? openSections.remove(key)
        : openSections.add(key);

    if (openSections.length > maxOpenSections) {
      openSections.removeRange(0, openSections.length - maxOpenSections);
    }
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}

final listCtrl = ListController();

/// The container list for all accordion sections. Usage:
/// ```dart
///	Accordion(
///		maxOpenSections: 1,
///		leftIcon: Icon(Icons.audiotrack, color: Colors.white),
///		children: [
///			AccordionSection(
///				isOpen: true,
///				header: Text('Introduction', style: TextStyle(color: Colors.white, fontSize: 20)),
///				content: Icon(Icons.airplanemode_active, size: 200),
///			),
///			AccordionSection(
///				isOpen: true,
///				header: Text('About Us', style: TextStyle(color: Colors.white, fontSize: 20)),
///				content: Icon(Icons.airline_seat_flat, size: 120),
///			),
///			AccordionSection(
///				isOpen: true,
///				header: Text('Company Info', style: TextStyle(color: Colors.white, fontSize: 20)),
///				content: Icon(Icons.airplay, size: 70, color: Colors.green[200]),
///			),
///		],
///	)
/// ```
class Accordion extends StatelessWidget with CommonParams {
  final List<AccordionSection>? children;
  final double paddingListHorizontal;
  final double paddingListTop;
  final double paddingListBottom;

  Accordion({
    Key? key,
    int? maxOpenSections,
    this.children,
    int? initialOpeningSequenceDelay,
    Color? headerBackgroundColor,
    double? headerBorderRadius,
    Widget? leftIcon,
    Widget? rightIcon,
    Widget? header,
    bool? flipRightIconIfOpen,
    Color? contentBackgroundColor,
    Color? contentBorderColor,
    double? contentBorderWidth,
    double? contentBorderRadius,
    double? contentHorizontalPadding,
    double? contentVerticalPadding,
    this.paddingListTop = 20.0,
    this.paddingListBottom = 40.0,
    this.paddingListHorizontal = 10.0,
    EdgeInsets? headerPadding,
    double? paddingBetweenOpenSections,
    double? paddingBetweenClosedSections,
    ScrollIntoViewOfItems? scrollIntoViewOfItems,
  }) : super(key: key) {
    listCtrl.initialOpeningSequenceDelay = initialOpeningSequenceDelay ?? 0;
    _headerBackgroundColor = headerBackgroundColor;
    _headerBorderRadius = headerBorderRadius;
    _leftIcon = leftIcon;
    _rightIcon = rightIcon;
    _flipRightIconIfOpen?.value = flipRightIconIfOpen ?? true;
    _contentBackgroundColor = contentBackgroundColor;
    _contentBorderColor = contentBorderColor;
    _contentBorderWidth = contentBorderWidth;
    _contentBorderRadius = contentBorderRadius ?? 10;
    _contentHorizontalPadding = contentHorizontalPadding;
    _contentVerticalPadding = contentVerticalPadding;
    _headerPadding = headerPadding ??
        const EdgeInsets.symmetric(horizontal: 15, vertical: 7);
    _paddingBetweenOpenSections = paddingBetweenOpenSections ?? 10;
    _paddingBetweenClosedSections = paddingBetweenClosedSections ?? 3;
    _scrollIntoViewOfItems = scrollIntoViewOfItems;

    int count = 0;
    listCtrl.maxOpenSections = maxOpenSections ?? 1;
    for (var child in children!) {
      if (child._sectionCtrl.isSectionOpen.value == true) {
        count++;

        if (count > listCtrl.maxOpenSections) {
          child._sectionCtrl.isSectionOpen.value = false;
        }
      }
    }
  }

  @override
  Widget build(context) {
    int index = 0;

    return Scrollbar(
      controller: listCtrl.controller,
      child: ListView(
        controller: listCtrl.controller,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: paddingListTop,
          bottom: paddingListBottom,
          right: paddingListHorizontal,
          left: paddingListHorizontal,
        ),
        cacheExtent: 100000,
        children: children!.map(
          (child) {
            final key = UniqueKey();

            if (child._sectionCtrl.isSectionOpen.value) {
              listCtrl.openSections.add(key);
            }

            return AutoScrollTag(
              key: ValueKey(key),
              controller: listCtrl.controller,
              index: index,
              child: AccordionSection(
                key: key,
                index: index++,
                isOpen: child._sectionCtrl.isSectionOpen.value,
                scrollIntoViewOfItems: _scrollIntoViewOfItems,
                headerBackgroundColor:
                    child._headerBackgroundColor ?? _headerBackgroundColor,
                headerBorderRadius:
                    child._headerBorderRadius ?? _headerBorderRadius,
                headerPadding: child._headerPadding ?? _headerPadding,
                header: child.header,
                leftIcon: child._leftIcon ?? _leftIcon,
                rightIcon: child._rightIcon ??
                    _rightIcon ??
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white60,
                      size: 20,
                    ),
                flipRightIconIfOpen: child._flipRightIconIfOpen?.value ??
                    _flipRightIconIfOpen?.value,
                paddingBetweenClosedSections:
                    child._paddingBetweenClosedSections ??
                        _paddingBetweenClosedSections,
                paddingBetweenOpenSections: child._paddingBetweenOpenSections ??
                    _paddingBetweenOpenSections,
                content: child.content,
                contentBackgroundColor:
                    child._contentBackgroundColor ?? _contentBackgroundColor,
                contentBorderColor:
                    child._contentBorderColor ?? _contentBorderColor,
                contentBorderWidth:
                    child._contentBorderWidth ?? _contentBorderWidth,
                contentBorderRadius:
                    child._contentBorderRadius ?? _contentBorderRadius,
                contentHorizontalPadding: child._contentHorizontalPadding ??
                    _contentHorizontalPadding,
                contentVerticalPadding:
                    child._contentVerticalPadding ?? _contentVerticalPadding,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class SectionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final controller = AnimationController(vsync: this);
  final isSectionOpen = false.obs;
  bool _firstRun = true;

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}

/// `AccordionSection` is one section within the `Accordion` widget.
/// Usage:
/// ```dart
///	Accordion(
///		maxOpenSections: 1,
///		leftIcon: Icon(Icons.audiotrack, color: Colors.white),
///		children: [
///			AccordionSection(
///				isOpen: true,
///				header: Text('Introduction', style: TextStyle(color: Colors.white, fontSize: 20)),
///				content: Icon(Icons.airplanemode_active, size: 200),
///			),
///			AccordionSection(
///				isOpen: true,
///				header: Text('About Us', style: TextStyle(color: Colors.white, fontSize: 20)),
///				content: Icon(Icons.airline_seat_flat, size: 120),
///			),
///			AccordionSection(
///				isOpen: true,
///				header: Text('Company Info', style: TextStyle(color: Colors.white, fontSize: 20)),
///				content: Icon(Icons.airplay, size: 70, color: Colors.green[200]),
///			),
///		],
///	)
/// ```
class AccordionSection extends StatelessWidget with CommonParams {
  late final SectionController _sectionCtrl;
  @override
  late final UniqueKey? key;
  late final int index;

  /// The text to be displayed in the header
  final Widget header;

  /// The widget to be displayed as the content of the section when open
  final Widget content;

  AccordionSection({
    this.key,
    this.index = 0,
    bool isOpen = false,
    required this.header,
    required this.content,
    Color? headerBackgroundColor,
    double? headerBorderRadius,
    EdgeInsets? headerPadding,
    Widget? leftIcon,
    Widget? rightIcon,
    bool? flipRightIconIfOpen = true,
    Color? contentBackgroundColor,
    Color? contentBorderColor,
    double? contentBorderWidth,
    double? contentBorderRadius,
    double? contentHorizontalPadding,
    double? contentVerticalPadding,
    double? paddingBetweenOpenSections,
    double? paddingBetweenClosedSections,
    ScrollIntoViewOfItems? scrollIntoViewOfItems,
  }) {
    _sectionCtrl = SectionController();
    _sectionCtrl.isSectionOpen.value = isOpen;

    _headerBackgroundColor = headerBackgroundColor;
    _headerBorderRadius = headerBorderRadius;
    _headerPadding = headerPadding;
    _leftIcon = leftIcon;
    _rightIcon = rightIcon;
    _flipRightIconIfOpen?.value = flipRightIconIfOpen ?? true;
    _contentBackgroundColor = contentBackgroundColor;
    _contentBorderColor = contentBorderColor;
    _contentBorderWidth = contentBorderWidth ?? 1;
    _contentBorderRadius = contentBorderRadius ?? 10;
    _contentHorizontalPadding = contentHorizontalPadding ?? 10;
    _contentVerticalPadding = contentVerticalPadding ?? 10;
    _paddingBetweenOpenSections = paddingBetweenOpenSections ?? 10;
    _paddingBetweenClosedSections = paddingBetweenClosedSections ?? 10;
    _scrollIntoViewOfItems =
        scrollIntoViewOfItems ?? ScrollIntoViewOfItems.fast;
  }

  get _flipQuarterTurns =>
      _flipRightIconIfOpen?.value == true ? (_isOpen ? 2 : 0) : 0;

  get _isOpen {
    final open = listCtrl.openSections.contains(key);

    Timer(
      _sectionCtrl._firstRun
          ? (listCtrl.initialOpeningSequenceDelay + min(index * 200, 1000))
              .milliseconds
          : 0.seconds,
      () {
        _sectionCtrl.controller
            .fling(velocity: open ? 1 : -1, springDescription: springFast);
        _sectionCtrl._firstRun = false;
      },
    );

    return open;
  }

  @override
  Widget build(context) {
    final _borderRadius = _headerBorderRadius ?? 10;

    return Obx(
      () => Column(
        key: key,
        children: [
          InkWell(
            onTap: () {
              listCtrl.updateSections(key!);

              if (_isOpen &&
                  _scrollIntoViewOfItems != ScrollIntoViewOfItems.none &&
                  listCtrl.controller.hasClients) {
                Timer(
                  0.25.seconds,
                  () {
                    listCtrl.controller.cancelAllHighlights();
                    listCtrl.controller.scrollToIndex(index,
                        preferPosition: AutoScrollPosition.middle,
                        duration: (_scrollIntoViewOfItems ==
                                    ScrollIntoViewOfItems.fast
                                ? .5
                                : 1)
                            .seconds);
                  },
                );
              }
            },
            child: AnimatedContainer(
              duration: 0.75.seconds,
              curve: Curves.easeOut,
              alignment: Alignment.center,
              padding: _headerPadding,
              decoration: BoxDecoration(
                color: _headerBackgroundColor ?? Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(_borderRadius),
                  bottom: Radius.circular(_isOpen ? 0 : _borderRadius),
                ),
              ),
              child: Row(
                children: [
                  if (_leftIcon != null) _leftIcon!,
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: _leftIcon == null ? 0 : 15),
                      child: header,
                    ),
                  ),
                  if (_rightIcon != null)
                    RotatedBox(
                        quarterTurns: _flipQuarterTurns, child: _rightIcon!),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: _isOpen
                    ? _paddingBetweenOpenSections!
                    : _paddingBetweenClosedSections!),
            child: SizeTransition(
              sizeFactor: _sectionCtrl.controller,
              child: ScaleTransition(
                scale: _sectionCtrl.controller,
                child: Center(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color:
                          _contentBorderColor ?? Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(_contentBorderRadius!)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        _contentBorderWidth ?? 1,
                        0,
                        _contentBorderWidth ?? 1,
                        _contentBorderWidth ?? 1,
                      ),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(
                                    _contentBorderRadius! / 1.02))),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: _contentBackgroundColor,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(
                                      _contentBorderRadius! / 1.02))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: _contentHorizontalPadding!,
                              vertical: _contentVerticalPadding!,
                            ),
                            child: Center(
                              child: content,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
