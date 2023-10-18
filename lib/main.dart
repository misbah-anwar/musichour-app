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

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp({required this.prefs});

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
              familyId: 33,
            ),
        '/timer': (context) => TimerPage(
              musicHour: '',
              prefs: prefs,
              familyId: 33,
            ),
      },
    );
  }
}

// Future<int> fetchFamilyId() async {
//   try {
//     var response = await http.get(
//       Uri.parse(
//           'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/getMusicFamilies'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );

//     if (response.statusCode == 200) {
//       var jsonData = jsonDecode(response.body);
//       return jsonData[0][
//           'family_id']; // Assuming family_id is in the first element of the response
//     } else {
//       throw Exception('Failed to load family_id');
//     }
//   } catch (error) {
//     print('Error fetching family_id: $error');
//     throw error;
//   }
// }
