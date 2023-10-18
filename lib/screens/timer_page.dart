import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class TimerPage extends StatefulWidget {
  final SharedPreferences prefs;

  TimerPage(
      {required this.prefs, required String musicHour, required int familyId});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late DateTime musicHourTime;
  late Duration remainingTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();

    String musicHour = widget.prefs.getString('music_hour') ?? '';
    musicHourTime = getUtcTime(musicHour);

    remainingTime = timeRemaining(musicHourTime);

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = timeRemaining(musicHourTime);
      });

      if (remainingTime.inSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  String formatTime(Duration duration) {
    return '${duration.inHours.toString().padLeft(2, '0')}h:${(duration.inMinutes % 60).toString().padLeft(2, '0')}m:${(duration.inSeconds % 60).toString().padLeft(2, '0')}s';
  }

  Duration timeRemaining(DateTime musicHourTime) {
    DateTime now = DateTime.now();
    return musicHourTime.isAfter(now)
        ? musicHourTime.difference(now)
        : Duration.zero;
  }

  DateTime getUtcTime(String musicHour) {
    DateTime now = DateTime.now();
    List<String> parts = musicHour.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    DateTime musicHourDateTime =
        DateTime(now.year, now.month, now.day, hour, minute);
    return tz.TZDateTime.from(musicHourDateTime, tz.local);
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = formatTime(remainingTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Page'),
      ),
      body: Center(
        child: Text(
          'Music Hour starts in $formattedTime',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
