// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:flutter/material.dart';

import 'package:fancai_client/views/screens/chat/chat_screen.dart';

/// TODO(naetherm): Need this?
import 'package:fancai_client/views/screens/dashboard/dashboard_screen.dart';
import 'package:fancai_client/views/screens/infocard/infocard_screen.dart';
import 'package:fancai_client/views/screens/medialibrary/medialibrary_screen.dart';
import 'package:fancai_client/views/screens/settings/settings_screen.dart';

class SidebarNavigation extends StatelessWidget {
  const SidebarNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Participant"),
            accountEmail: Text("naem@hs-furtwangen.de"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/coaches/fred.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://lh3.googleusercontent.com/quk4diz1Dbg_FrVOSN4nOSKtqobokocb6siq51b9DzJj-1MCyiJR56QPx0rOSprzCw9TuAYy-K7lKH6RSIhsCAGR_HbENIwVGYSzeb4=s0')),
            ),
          ),
          ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chat'),
              onTap: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => ChatScreen())),
              trailing: ClipOval(
                  child: Container(
                      color: Colors.red,
                      width: 20,
                      height: 20,
                      child: Center(
                          child: Text('8',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              )))))),
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('Infocards'),
            onTap: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => InfocardsScreen())),
          ),
          ListTile(
            leading: Icon(Icons.video_library),
            title: Text('Media Library'),
            onTap: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => MediaLibraryScreen())),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => SettingsScreen())),
          ),
        ],
      ),
    );
  }
}
