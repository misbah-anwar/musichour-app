import 'package:flutter/material.dart';
import 'package:music_hour_app/screens/family_details_page.dart';
import 'package:music_hour_app/screens/user_login_page.dart';
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
              child: Text('Admin'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserLoginPage(
                      prefs: prefs,
                      familyId: -1,
                    ),
                  ),
                );
              },
              child: Text('User'),
            ),
          ],
        ),
      ),
    );
  }
}
