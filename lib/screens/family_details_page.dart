import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyDetailsPage extends StatefulWidget {
  final SharedPreferences prefs;

  FamilyDetailsPage({required this.prefs});

  @override
  _FamilyDetailsPageState createState() => _FamilyDetailsPageState();
}

class _FamilyDetailsPageState extends State<FamilyDetailsPage> {
  TextEditingController familyNameController = TextEditingController();
  TextEditingController musicHourController = TextEditingController();

  Future<void> _submitFamilyDetails() async {
    try {
      var response = await http.post(
        Uri.parse(
            'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/addMusicFamily'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'family_name': familyNameController.text,
          'music_hour': musicHourController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Successful submission
        print('Family Details submitted successfully');

        // Print the response body as string
        String responseBody = response.body;
        print('Response body: $responseBody');

        // Now convert the response to a JSON object
        var jsonData = jsonDecode(responseBody);

        // Access the family ID
        int familyId = jsonData['family_id'];

        // Store familyId and musicHour in SharedPreferences
        await widget.prefs.setInt('family_id', familyId);
        await widget.prefs.setString('music_hour', jsonData['music_hour']);

        // Navigate to next screen
        await _fetchFamilyDetails();
      } else {
        // Handle errors here
        print('Failed to submit Family Details');
      }
    } catch (error) {
      print('Error submitting family details: $error');
    }
  }

  Future<void> _fetchFamilyDetails() async {
    try {
      var response = await http.get(
        Uri.parse(
            'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/getMusicFamilies'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Successful response
        print('Fetched family details successfully');

        // Convert the response to a JSON object
        var jsonData = jsonDecode(response.body);

        // Access the family ID
        int familyId = jsonData['family_id'];

        // Store family details in SharedPreferences
        await widget.prefs.setInt('family_id', familyId);
        await widget.prefs.setString('family_name', jsonData['family_name']);
        await widget.prefs.setString('music_hour', jsonData['music_hour']);

        // Navigate to next screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminDetailsPage(
              prefs: widget.prefs,
              familyId: familyId,
            ),
          ),
        );
      } else {
        // Handle errors here
        print('Failed to fetch family details');
      }
    } catch (error) {
      print('Error fetching family details: $error');
    }
  }

  void _cancel() {
    setState(() {
      familyNameController.clear();
      musicHourController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Details'),
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
              controller: musicHourController,
              decoration: InputDecoration(labelText: 'Music Hour (HH:mm)'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _submitFamilyDetails,
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
