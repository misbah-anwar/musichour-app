import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MusicContentPage extends StatelessWidget {
  final int familyId;

  MusicContentPage({required this.familyId});

  Future<void> _addMusicContent(String content) async {
    var response = await http.post(
      Uri.parse(
          'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/addMusicContentByFamilyName'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'family_id': familyId,
        'content': content,
      }),
    );

    if (response.statusCode == 200) {
      print('Music content added successfully');
    } else {
      print('Failed to add music content');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Content Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (content) {
                // Update content as user types
              },
              decoration: InputDecoration(labelText: 'Music Content'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Pass the content to the function when button is pressed
                _addMusicContent('Content here');
              },
              child: Text('Add Music Content'),
            ),
          ],
        ),
      ),
    );
  }
}
