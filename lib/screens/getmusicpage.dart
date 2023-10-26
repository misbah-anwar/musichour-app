import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetMusicPage extends StatefulWidget {
  final SharedPreferences prefs;
  final int familyId;

  GetMusicPage({
    required this.prefs,
    required this.familyId,
  });

  @override
  _GetMusicPageState createState() => _GetMusicPageState();
}

class _GetMusicPageState extends State<GetMusicPage> {
  late Future<String> videoUrl;
  int itemAvailable = 1;
  int count = 0;
  int position = 0;

  late YoutubePlayerController _controller;

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
      List jsonData = jsonDecode(response.body);
      count = jsonData.length;

      if (jsonData is List && jsonData.isNotEmpty) {
        print("controller:");
        print(_controller.metadata.duration.inMilliseconds);
        var currentItem = jsonData[position];
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
            _controller = YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(snapshot.data!)!,
              flags: YoutubePlayerFlags(
                autoPlay: true,
                mute: false,
              ),
            );

            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blueAccent,
                    ),
                    Text(
                      'Remaining Time: ${(_controller.metadata.duration.inMilliseconds)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text("playing item " +
                        (position + 1).toString() +
                        " of " +
                        count.toString())
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
