import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MusicContentPage extends StatefulWidget {
  final int familyId;
  final SharedPreferences prefs;

  MusicContentPage({required this.familyId, required this.prefs});

  @override
  _MusicContentPageState createState() => _MusicContentPageState();
}

class _MusicContentPageState extends State<MusicContentPage> {
  TextEditingController musicUrlController = TextEditingController();
  TextEditingController familyNameController = TextEditingController();
  int? statusCode;

  Future<void> _addMusicContent() async {
    try {
      var response = await http.post(
        Uri.parse(
          'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/addMusicContentByFamilyName',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          //'family_name': family,
          'music_url': musicUrlController.text,
          'family_name': familyNameController.text,
        }),
      );
      setState(() {
        statusCode = response.statusCode; // Update status code variable
      });

      if (response.statusCode == 200) {
        print('Music content added successfully');
        print(response.statusCode);
        String responseBody = response.body;
        print('Response body: $responseBody');
        //String responseBody = response.body;
        //print('Response body: $responseBody');
        var jsonData = jsonDecode(responseBody);
        String musicurl = jsonData['music_url'];
        print(musicurl);
        print("printing music url ........");
        // Store musicurl in SharedPreferences
        // await widget.prefs.setString('music_url', jsonData['music_url']);
        // print(widget.prefs.getString('music_url'));
      } else {
        print('Failed to add music content');
      }
    } catch (error) {
      print('Error adding music content: $error');
    }
  }

  void _cancel() {
    setState(() {
      musicUrlController.clear();
      familyNameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Music Content'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: musicUrlController,
              decoration: InputDecoration(labelText: 'Music Content'),
            ),
            TextField(
              controller: familyNameController,
              decoration: InputDecoration(labelText: 'Family Name'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _addMusicContent,
                  child: Text('Submit'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _cancel,
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
