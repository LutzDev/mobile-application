// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:flutter/material.dart';
import 'package:fancai_client/core/storage.dart';
import 'package:fancai_client/views/screens/introduction/introduction_screen.dart';
import 'package:fancai_client/views/screens/chat/chat_screen.dart';

/// TODO(naetherm): Dependent on the current state (onboarding_finished)
///                 initialize the correct screen (either Introduction or Chat)

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(9, (index) {
          return Center(
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        }),
      ),
    );
  }
}
