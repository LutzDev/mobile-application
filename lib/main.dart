// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fancai_client/core/storage.dart';
import 'package:fancai_client/views/screens/introduction/introduction_screen.dart';
import 'package:fancai_client/views/screens/chat/chat_screen.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool startWithChatScreen = false;
    // Wrap around the problem that we are asking for a future value but the
    // method build is not async.
    Future.delayed(const Duration(seconds: 5), () async {
      // We are querying the internal app memory (which is also serialized to device)
      // wether the participant already did the onboarding
      startWithChatScreen =
          await Storage.instance.containsKey("onboarding_finished");
    });
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
        title: 'Home',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: startWithChatScreen
            ? const ChatScreen()
            : const IntroductionPage());
  }
}
