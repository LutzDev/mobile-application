// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:flutter/material.dart';
import 'package:fancai_client/views/widgets/navigation/sidebar_navigation.dart';

class InfocardsScreen extends StatelessWidget {
  const InfocardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infocards'),
      ),
      drawer: SidebarNavigation(),
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
