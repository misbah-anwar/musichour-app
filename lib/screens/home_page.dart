import 'package:flutter/material.dart';
import 'package:music_hour_app/screens/family_details_page.dart';
import 'package:music_hour_app/screens/getmusicpage.dart';
import 'package:music_hour_app/screens/music_content_page.dart';
import 'package:music_hour_app/screens/user_access_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final SharedPreferences prefs;

  HomePage({required this.prefs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
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
                    builder: (context) => FamilyDetailsPage(prefs: prefs),
                  ),
                );
              },
              child: Text('Admin-Add Family'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicContentPage(
                      prefs: prefs,
                      familyId: 41,
                    ),
                  ),
                );
              },
              child: Text('Admin-Add Music'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserAccessPage(
                      familyId: 33,
                      prefs: prefs,
                    ),
                  ),
                );
              },
              child: Text('User Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GetMusicPage(
                      prefs: prefs,
                      familyId: 41,
                    ),
                  ),
                );
              },
              child: Text('User- Get Music'),
            ),
          ],
        ),
      ),
    );
  }
}
