import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'admin_page.dart';

class AdminDetailsPage extends StatefulWidget {
  final SharedPreferences prefs;
  final int familyId;

  AdminDetailsPage({
    required this.prefs,
    required this.familyId,
    required String musicHour,
  });

  @override
  _AdminDetailsPageState createState() => _AdminDetailsPageState();
}

class _AdminDetailsPageState extends State<AdminDetailsPage> {
  TextEditingController adminNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController familyNameController = TextEditingController();

  Future<void> _submitAdminDetails() async {
    try {
      var response = await http.post(
        Uri.parse(
          'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/addMusicUserByFamilyName',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'family_id': widget.familyId,
          'family_name': familyNameController.text,
          'user_name': adminNameController.text,
          'email': emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        print('Admin Details submitted successfully');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPage(
              familyId: widget.familyId,
              prefs: widget.prefs,
              //musicHourFuture: fetchMusicHour(),
            ),
          ),
        );
      } else {
        print('Failed to submit Admin Details');
      }
    } catch (error) {
      print('Error fetching music hour: $error');
    }
  }

  Future<String> fetchMusicHour() async {
    try {
      var response = await http.get(
        Uri.parse(
          'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/getMusicFamilies',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData is List && jsonData.isNotEmpty) {
          return jsonData[0]
              ['music_hour']; // Access 'music_hour' directly from the response
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load music hour');
      }
    } catch (error) {
      print('Error fetching music hour: $error');
      throw error;
    }
  }

  Future<String> fetchMusicHourByFamilyId(int familyId) async {
    try {
      var response = await http.get(
        Uri.parse(
          'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/getMusicFamilyByFamilyId/$familyId',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        String musicHour = jsonData['music_hour'];
        return musicHour;
      } else {
        throw Exception('Failed to load music hour');
      }
    } catch (error) {
      print('Error fetching music hour: $error');
      throw error;
    }
  }

  void _cancel() {
    setState(() {
      adminNameController.clear();
      emailController.clear();
      familyNameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Admin Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: familyNameController,
              decoration: InputDecoration(labelText: 'Family Name'),
            ),
            TextField(
              controller: adminNameController,
              decoration: InputDecoration(labelText: 'Admin Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email Id'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _submitAdminDetails,
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
