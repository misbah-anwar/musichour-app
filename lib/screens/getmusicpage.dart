import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GetMusicPage extends StatefulWidget {
  final SharedPreferences prefs;

  GetMusicPage({required this.prefs, required int familyId});

  @override
  _GetMusicPageState createState() => _GetMusicPageState();
}

class _GetMusicPageState extends State<GetMusicPage> {
  Future<void> _fetchMusicDetails() async {
    try {
      var response = await http.get(
        Uri.parse(
            'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/getMusicContentByFamilyId/41'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Successful response
        print('Fetched music details successfully');

        // Convert the response to a JSON object
        var jsonData = jsonDecode(response.body);
        print(jsonData);
        await _fetchMusicDetails();
      } else {
        // Handle errors here
        print('Failed to fetch music details');
      }
    } catch (error) {
      print('Error fetching music details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Music'),
      ),
    );
  }
}
