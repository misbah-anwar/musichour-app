import 'dart:convert';
import 'package:http/http.dart' as http;

class MusicService {
  Future<String> getMusicHour() async {
    var response = await http.get(
      Uri.parse(
          'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/getMusicFamilyByFamilyId/33'),
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      String musicHour = jsonData['musicHour'];
      return musicHour;
    } else {
      throw Exception('Failed to get musicHour');
    }
  }
}
