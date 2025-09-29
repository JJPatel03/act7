import 'dart:math'; // for Random
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MoodModel(),
      child: MyApp(),
    ),
  );
}

// Mood Model - The "Brain" of our app
class MoodModel with ChangeNotifier {
  String _currentMood =
      'assets/80125-art-character-question-fictional-mark-animation-cartoon.jpeg';
  Color _backgroundColor = Colors.white; // default background

  // Mood counters
  final Map<String, int> _moodCounts = {
    'Happy': 0,
    'Sad': 0,
    'Angry': 0,
  };

  String get currentMood => _currentMood;
  Color get backgroundColor => _backgroundColor;
  Map<String, int> get moodCounts => _moodCounts;

  void setHappy() {
    _currentMood =
        'assets/65057-emoticon-signal-smiley-thumb-emoji-free-frame.jpeg';
    _backgroundColor = Colors.yellow;
    _moodCounts['Happy'] = _moodCounts['Happy']! + 1;
    notifyListeners();
  }

  void setSad() {
    _currentMood = 'assets/36885-5-sad-emoji-photos.jpeg';
    _backgroundColor = Colors.blue;
    _moodCounts['Sad'] = _moodCounts['Sad']! + 1;
    notifyListeners();
  }

  void setAngry() {
    _currentMood = 'assets/36773-6-angry-emoji-photos.jpeg';
    _backgroundColor = Colors.orange;
    _moodCounts['Angry'] = _moodCounts['Angry']! + 1;
    notifyListeners();
  }

  // New: Random mood generator (only picks existing moods)
  void setRandomMood() {
    final random = Random().nextInt(3); // 0, 1, or 2
    switch (random) {
      case 0:
        setHappy();
        break;
      case 1:
        setSad();
        break;
      case 2:
        setAngry();
        break;
    }
  }
}

// Main App Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moodModel = context.watch<MoodModel>();

    return Scaffold(
      appBar: AppBar(title: Text('Mood Toggle Challenge')),
      backgroundColor: moodModel.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('How are you feeling?', style: TextStyle(fontSize: 24)),
            SizedBox(height: 30),
            MoodDisplay(),
            SizedBox(height: 50),
            MoodButtons(),
            SizedBox(height: 20),
            RandomMoodButton(), //New random mood button
            SizedBox(height: 30),
            MoodCounter(),
          ],
        ),
      ),
    );
  }
}

// Widget that displays the current mood
class MoodDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Image.asset(
          moodModel.currentMood,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        );
      },
    );
  }
}

// Widget with buttons to change the mood
class MoodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setHappy();
          },
          child: Text('Happy'),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setSad();
          },
          child: Text('Sad'),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setAngry();
          },
          child: Text('Angry'),
        ),
      ],
    );
  }
}

// New widget for random mood button
class RandomMoodButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        Provider.of<MoodModel>(context, listen: false).setRandomMood();
      },
      label: Text(
        "Random Mood",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Widget to show mood counters
class MoodCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        final counts = moodModel.moodCounts;

        return Column(
          children: [
            Text(
              "Mood Counts:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCounterBox("Happy", counts["Happy"]!),
                _buildCounterBox("Sad", counts["Sad"]!),
                _buildCounterBox("Angry", counts["Angry"]!),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildCounterBox(String mood, int count) {
    return Column(
      children: [
        Text(
          mood,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        Text(
          count.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
