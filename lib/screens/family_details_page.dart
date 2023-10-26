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
  int? statusCode;
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
      setState(() {
        statusCode = response.statusCode; // Update status code variable
      });

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
        //String familyName = jsonData['family_name'];
        print(familyId);
        print("printing family id ........");
        // Store familyId and musicHour in SharedPreferences
        await widget.prefs.setInt('family_id', familyId);
        await widget.prefs.setString('music_hour', jsonData['music_hour']);
        await widget.prefs.setString('family_name', jsonData['family_name']);
        print(widget.prefs.getInt('family_id'));

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

        if (jsonData is List && jsonData.isNotEmpty) {
          var family = jsonData.last;
          int familyId = family['family_id'];

          // Store family details in SharedPreferences
          await widget.prefs.setInt('family_id', familyId);
          await widget.prefs.setString('family_name', family['family_name']);
          await widget.prefs.setString('music_hour', family['music_hour']);
          print(widget.prefs.getKeys());
          print(widget.prefs.getInt('family_id'));
          print(widget.prefs.getString('music_hour'));
          print(widget.prefs.getString('family_name'));

          // Navigate to next screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminDetailsPage(
                prefs: widget.prefs,
                familyId: familyId,
                musicHour: '',
              ),
            ),
          );
        } else {
          // Handle empty response or invalid format
          throw Exception('Invalid response format');
        }
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
        title: Text('Add Family Details'),
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
            if (statusCode != null)
              Text(
                'Status Code: $statusCode',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
