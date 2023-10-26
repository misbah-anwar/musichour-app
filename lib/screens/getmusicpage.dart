import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetMusicPage extends StatefulWidget {
  final SharedPreferences prefs;
  final int familyId;

  GetMusicPage({required this.prefs, required this.familyId});

  @override
  _GetMusicPageState createState() => _GetMusicPageState();
}

class _GetMusicPageState extends State<GetMusicPage> {
  late Future<String> videoUrl;
  int itemAvailable = 1;

  @override
  void initState() {
    super.initState();
    videoUrl = fetchVideoUrl();
  }

  Future<String> fetchVideoUrl() async {
    final response = await http.get(
      Uri.parse(
          'http://baatcheet1-env.eba-3uzrj2rz.us-east-2.elasticbeanstalk.com/getMusicContentByFamilyId/${widget.familyId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print("response:" + response.body);

      if (jsonData is List && jsonData.isNotEmpty) {
        var currentItem = jsonData[2];
        if (currentItem.containsKey('music_url')) {
          return currentItem['music_url'];
        } else {
          throw Exception('music_url not found in response');
        }
      } else {
        throw Exception('Empty or invalid response from the API');
      }
    } else {
      itemAvailable = 0;
      throw Exception('Failed to load video URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Music'),
      ),
      body: FutureBuilder<String>(
        future: videoUrl,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            print('Video URL received: ${snapshot.data}');
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId:
                            YoutubePlayer.convertUrlToId(snapshot.data!)!,
                        flags: YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blueAccent,
                    ),
                    Text("flag")
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
