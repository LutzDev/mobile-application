// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class DateBuilder extends StatelessWidget {
  DateBuilder({
    required this.date,
    this.customDateBuilder,
    this.dateFormat,
  });

  final DateTime date;
  final Widget Function(String)? customDateBuilder;
  final intl.DateFormat? dateFormat;

  @override
  Widget build(BuildContext context) {
    return customDateBuilder?.call(dateFormat?.format(date) ??
            intl.DateFormat('yyyy-MM-dd').format(date)) ??
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.only(
            bottom: 5.0,
            top: 5.0,
            left: 10.0,
            right: 10.0,
          ),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            dateFormat != null
                ? dateFormat!.format(date)
                : intl.DateFormat('yyyy-MMM-dd').format(date),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        );
  }
}
