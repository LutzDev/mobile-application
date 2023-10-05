// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:flutter/material.dart';
import 'package:fancai_client/views/widgets/navigation/sidebar_navigation.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _OnDashboardPageState createState() => _OnDashboardPageState();
}

class _OnDashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO(naetherm): implement build, is this really necessary?
    throw Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const SidebarNavigation(),
    );
  }
}
