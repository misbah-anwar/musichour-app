import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:music_hour_app/screens/home_page.dart';
import 'package:music_hour_app/screens/family_details_page.dart';
import 'package:music_hour_app/screens/user_login_page.dart';
import 'package:music_hour_app/screens/timer_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Fetch the family_id
  int familyId = await fetchFamilyId();

  // Store the family_id in SharedPreferences
  prefs.setInt('family_id', familyId);

  runApp(MyApp(prefs: prefs, familyId: familyId));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final int familyId;

  MyApp({required this.prefs, required this.familyId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Hour App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(prefs: prefs),
        '/admin': (context) => FamilyDetailsPage(prefs: prefs),
        '/user': (context) => UserLoginPage(
              prefs: prefs,
              familyId: familyId,
            ),
        '/timer': (context) => TimerPage(musicHour: ''),
      },
    );
  }
}

Future<int> fetchFamilyId() async {
  try {
    var response = await http.get(
      Uri.parse(
          'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/getMusicFamilies'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData[0][
          'family_id']; // Assuming family_id is in the first element of the response
    } else {
      throw Exception('Failed to load family_id');
    }
  } catch (error) {
    print('Error fetching family_id: $error');
    throw error;
  }
}
