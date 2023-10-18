import 'package:flutter/material.dart';
import 'user_login_page.dart';
import 'music_content_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatelessWidget {
  final int familyId;
  final SharedPreferences prefs;
  //final Future<String> musicHourFuture;

  AdminPage({
    required this.familyId,
    required this.prefs,
    //required this.musicHourFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserLoginPage(
                      prefs: prefs,
                      familyId: 33,
                    ),
                  ),
                );
              },
              child: Text('Add User'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicContentPage(
                      familyId: familyId,
                      prefs: prefs,
                    ),
                  ),
                );
              },
              child: Text('Add Music'),
            ),
          ],
        ),
      ),
    );
  }
}
