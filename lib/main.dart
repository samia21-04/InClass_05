import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MaterialApp(home: DigitalPetApp()));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int happyStreakSeconds = 0;
  int energyLevel = 80; // 0 to 100
  String selectedActivity = "Run";

final List<String> activities = ["Run", "Sleep", "Play"];



  @override
void initState() {
  super.initState();

  // Timer 1: Hunger increases every 30 seconds
  Timer.periodic(Duration(seconds: 30), (timer) {
    setState(() {
      hungerLevel += 5;
    });
  });

  // Timer 2: Check happiness every 1 second
  Timer.periodic(Duration(seconds: 1), (timer) {
    if (happinessLevel > 80) {
      happyStreakSeconds++;
    } else {
      happyStreakSeconds = 0;
    }

    if (happyStreakSeconds >= 180) {
      print("You Win!");
    }
  });
}




  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
      _checkLossCondition();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    hungerLevel += 5;
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel -= 20;
    }
  }
// Function to determine the color based on happiness level
  Color _moodColor(int happinessLevel) {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
  }
//Pet Mood Indicator
String _moodText(){
  if (happinessLevel > 75) return "Happy";
  if (happinessLevel >= 40) return "Neutral";
  return "Sad";
}

final TextEditingController _nameController = TextEditingController();

void _setPetName() {
  setState(() {
    petName = _nameController.text;
    _nameController.clear();
  });
}

void _checkLossCondition(){
  if (hungerLevel >= 100 && happinessLevel <=10) {
    print("Game Over");
  }
}

void _doSelectedActivity() {
  setState(() {
    if (selectedActivity == "Run") {
      // Running uses energy and increases hunger, but can increase happiness
      energyLevel = (energyLevel - 20).clamp(0, 100);
      hungerLevel = (hungerLevel + 10).clamp(0, 100);
      happinessLevel = (happinessLevel + 5).clamp(0, 100);

    } else if (selectedActivity == "Sleep") {
      // Sleeping restores energy, but time passes so hunger increases a bit
      energyLevel = (energyLevel + 30).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100);

    } else if (selectedActivity == "Play") {
      // Playing increases happiness but uses some energy + increases hunger
      happinessLevel = (happinessLevel + 15).clamp(0, 100);
      energyLevel = (energyLevel - 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
    }

    // Optional: if energy is too low, happiness drops
    if (energyLevel <= 10) {
      happinessLevel = (happinessLevel - 5).clamp(0, 100);
    }
  });
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Digital Pet')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Name: $petName', style: const TextStyle(fontSize: 20.0)),
          const SizedBox(height: 16.0),
          Text('Happiness Level: $happinessLevel', style: const TextStyle(fontSize: 20.0)),
          const SizedBox(height: 16.0),
          Text('Hunger Level: $hungerLevel', style: const TextStyle(fontSize: 20.0)),
          const SizedBox(height: 24.0),

          Text(
            "Mood: ${_moodText()}",
            style: const TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 16.0),

          // 👇 Name input + button go together in a Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 180,
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Pet Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _setPetName,
                child: const Text("Set Name"),
              ),
            ],
          ),

          const SizedBox(height: 24.0),

          Text('Energy Level: $energyLevel', style: const TextStyle(fontSize: 20.0)),
        const SizedBox(height: 8.0),
        SizedBox(
          width: 250,
          child: LinearProgressIndicator(
          value: energyLevel / 100, // convert 0-100 to 0.0-1.0
          minHeight: 12,
        ),
      ),
        const SizedBox(height: 16.0),

        const SizedBox(height: 16.0),
Text("Choose an activity:", style: const TextStyle(fontSize: 18)),
DropdownButton<String>(
  value: selectedActivity,
  items: activities.map((activity) {
    return DropdownMenuItem(
      value: activity,
      child: Text(activity),
    );
  }).toList(),
  onChanged: (value) {
    if (value == null) return;
    setState(() {
      selectedActivity = value;
    });
  },
),
ElevatedButton(
  onPressed: _doSelectedActivity,
  child: const Text("Do Activity"),
),
const SizedBox(height: 16.0),



          ElevatedButton(
            onPressed: _playWithPet,
            child: const Text('Play with Your Pet'),
          ),
          const SizedBox(height: 16.0),

          ElevatedButton(
            onPressed: _feedPet,
            child: const Text('Feed Your Pet'),
          ),

          const SizedBox(height: 24.0),

          ColorFiltered(
            colorFilter: ColorFilter.mode(
              _moodColor(happinessLevel),
              BlendMode.modulate,
            ),
            child: Image.asset('assets/pet_image.png'),
          ),
        ],
      ),
    ),
  );
}
}