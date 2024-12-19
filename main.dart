// main.dart

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'dashboardpage.dart';
import 'QuizZonePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return LoginScreen();
            } else {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.done) {
                    var userData = userSnapshot.data;
                    return DashboardPage(
                      userName: userData?['name'] ?? 'User',
                      coinBalance: userData?['coin_balance'] ?? 500,
                    );
                  }
                  return CircularProgressIndicator();
                },
              );
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
*/

/*
this code is working to create questions*/
/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _createQuizData();
  }

  Future<void> _createQuizData() async {
    CollectionReference quizCollection = _firestore.collection('quiz');
    DocumentReference quizDoc = quizCollection.doc('1'); // Document ID for the quiz
    CollectionReference levelsCollection = quizDoc.collection('levels');

    Map<String, dynamic> question0 = {
  'correct_answer': '2',
  'options': ['1', '2', '3', '4'],
  'question': 'What is the value of √4?',
};

Map<String, dynamic> question1 = {
  'correct_answer': '90°',
  'options': ['30°', '60°', '90°', '120°'],
  'question': 'What is the angle between the diagonals of a square?',
};

Map<String, dynamic> question2 = {
  'correct_answer': '120°',
  'options': ['90°', '120°', '150°', '180°'],
  'question': 'What is the bond angle in a molecule of methane?',
};

Map<String, dynamic> question3 = {
  'correct_answer': 'C2H6',
  'options': ['CH4', 'C2H6', 'C3H8', 'C4H10'],
  'question': 'What is the molecular formula of ethane?',
};

Map<String, dynamic> question4 = {
  'correct_answer': '180 m/s',
  'options': ['90 m/s', '120 m/s', '150 m/s', '180 m/s'],
  'question': 'If a car accelerates uniformly at 3 m/s² for 60 seconds, what is its final velocity?',
};

Map<String, dynamic> question5 = {
  'correct_answer': '1',
  'options': ['1', '0', 'Infinity', 'Undefined'],
  'question': 'What is the value of sin²θ + cos²θ?',
};

Map<String, dynamic> question6 = {
  'correct_answer': '100',
  'options': ['50', '100', '200', '500'],
  'question': 'If a charge of 10 C is placed in an electric field of strength 10 N/C, what is the force acting on it?',
};

Map<String, dynamic> question7 = {
  'correct_answer': '3',
  'options': ['1', '2', '3', '4'],
  'question': 'How many electrons are present in the outermost shell of an atom of aluminum?',
};

Map<String, dynamic> question8 = {
  'correct_answer': '4 cm²',
  'options': ['1 cm²', '2 cm²', '3 cm²', '4 cm²'],
  'question': 'What is the area of a square with a diagonal of 2√2 cm?',
};

Map<String, dynamic> question9 = {
  'correct_answer': '1/3',
  'options': ['1', '1/2', '1/3', '1/4'],
  'question': 'What is the probability of getting a prime number when rolling a standard die?',
};


    List<Map<String, dynamic>> questions = [question0, question1, question2, question3, question4, question5, question6, question7, question8, question9];

    // Add level 1
    await levelsCollection.doc('1').set({
      'level_number': 1,
      'questions': questions,
    });

    // Add another level (example)
    await levelsCollection.doc('2').set({
      'level_number': 2,
      'questions': questions,
    });

    print('Quiz data created successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Quiz'),
      ),
      body: Center(
        child: Text('Check Firestore for quiz data.'),
      ),
    );
  }
}
*/
//code to create the leaderboard collection
/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Initialize Firebase
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaderboard Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LeaderboardDemo(),
    );
  }
}

class LeaderboardDemo extends StatelessWidget {
  // Function to update the leaderboard
  Future<void> updateLeaderboard({
    required String name,
    required String email,
    required int level,
    required int score,
    required int time,
  }) async {
    try {
      CollectionReference leaderboard =
      FirebaseFirestore.instance.collection('leaderboard');

      // Add a new entry to the leaderboard or update the user's entry
      await leaderboard.add({
        'name': name,
        'email': email,
        'level': level,
        'score': score,
        'time': time,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Leaderboard updated successfully");
    } catch (e) {
      print("Error updating leaderboard: $e");
    }
  }

  // Function to trigger leaderboard entry creation
  void createLeaderboardEntry(BuildContext context) {
    updateLeaderboard(
      name: "John Doe",
      email: "john.doe@example.com",
      level: 1,
      score: 15,
      time: 90,
    ).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Leaderboard entry added!")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => createLeaderboardEntry(context),
          child: Text('Add Leaderboard Entry'),
        ),
      ),
    );
  }
}
*/

/*this is the main code uncomment it*/

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'DashboardPage.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return LoginScreen();
            } else {
              // Use FutureBuilder to fetch user details from Firestore
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.done) {
                    var userData = userSnapshot.data?.data() as Map<String, dynamic>?;

                    // Pass user data to DashboardPage or provide defaults if data is null
                    return DashboardPage(
                      userName: userData?['name'] ?? 'User',
                      coinBalance: userData?['coin_balance'] ?? 500,


                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Timer? _timer; // Timer to recheck the quiz access
  bool quizUnlocked = false; // Flag to track if quiz is unlocked

  @override
  void initState() {
    super.initState();
    // Check quiz access immediately and start periodic rechecks every 1 minute
    checkQuizAccess();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      checkQuizAccess();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the page is disposed
    super.dispose();
  }

  void checkQuizAccess() async {
    try {
      // Update Firestore with the current server timestamp
      await FirebaseFirestore.instance
          .collection('server_time')
          .doc('current_time')
          .set({
        'time': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Fetch the updated server time and quiz unlock time
      final serverTimeDoc = await FirebaseFirestore.instance
          .collection('server_time')
          .doc('current_time')
          .get();

      final quizTimeDoc = await FirebaseFirestore.instance
          .collection('server_time')
          .doc('quiz_time')
          .get();

      // Extract timestamps
      final Timestamp serverTimestamp = serverTimeDoc['time'];
      final Timestamp quizUnlockTimestamp = quizTimeDoc['time'];

      final DateTime serverDateTime = serverTimestamp.toDate();
      final DateTime quizUnlockTime = quizUnlockTimestamp.toDate();

      print("Server Time: $serverDateTime");
      print("Quiz Unlock Time: $quizUnlockTime");

      if (serverDateTime.isBefore(quizUnlockTime)) {
        setState(() {
          quizUnlocked = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("The quiz will be live at ${quizUnlockTime.hour}:${quizUnlockTime.minute}."),
          ),
        );
      } else {
        setState(() {
          quizUnlocked = true;
        });
      }
    } catch (e) {
      print("Error fetching or updating server time: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching server time.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: ElevatedButton(
          onPressed: quizUnlocked
              ? () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StartQuizPage()),
          )
              : () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("The quiz is not live yet.")),
            );
          },
          child: Text("Math Quiz"),
        ),
      ),
    );
  }
}

class StartQuizPage extends StatefulWidget {
  @override
  _StartQuizPageState createState() => _StartQuizPageState();
}

class _StartQuizPageState extends State<StartQuizPage> {
  int _secondsRemaining = 120; // 2-minute countdown
  bool _isCountdownComplete = false; // To track countdown status
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isCountdownComplete = true;
          _timer?.cancel(); // Stop the timer
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  void _startQuiz() {
    // Navigate to the Quiz Questions Page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizQuestionsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Get Ready!")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Quiz starts in:", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(_formattedTime, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isCountdownComplete ? _startQuiz : null,
              child: Text("Start Quiz"),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizQuestionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz Questions")),
      body: Center(
        child: Text(
          "Here are your quiz questions!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RewardedAdExample(),
    );
  }
}

class RewardedAdExample extends StatefulWidget {
  @override
  _RewardedAdExampleState createState() => _RewardedAdExampleState();
}

class _RewardedAdExampleState extends State<RewardedAdExample> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  int _rewardCount = 0;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Replace with your ad unit ID
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
          print('Ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          print('Failed to load rewarded ad: ${error.message}');
          _isAdLoaded = false;
          Future.delayed(Duration(seconds: 5), _loadRewardedAd); // Retry after delay
        },
      ),
    );
  }


  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        setState(() {
          _rewardCount += 1;
        });
        print('Reward earned: ${reward.amount}');
      });

      // Dispose the ad after it's shown
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadRewardedAd(); // Reload a new ad
        },
      );
    } else {
      print('Ad not loaded');
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rewarded Ad Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Reward Count: $_rewardCount'),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _isAdLoaded ? _showRewardedAd : null,
              child: Icon(Icons.ads_click),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*
this is the code to add a new field in the user collection
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firestore Update',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  // Function to add the 'rewarded' field to all users
  Future<void> addFieldToAllUsers() async {
    try {
      // Reference to the 'users' collection
      final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

      // Fetch all documents in the 'users' collection
      final QuerySnapshot querySnapshot = await usersRef.get();

      // Loop through each document and add the 'rewarded' field
      for (var doc in querySnapshot.docs) {
        await usersRef.doc(doc.id).update({'rewarded': 0});
      }

      // Success message
      debugPrint("Field 'rewarded' added to all users with initial value 0.");
    } catch (e) {
      debugPrint("Error updating users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Update Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Call the function to update users
            addFieldToAllUsers();
          },
          child: Text('Add Field to All Users'),
        ),
      ),
    );
  }
}

*/
/*
import 'package:flutter/material.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Quiz App'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.account_circle, size: 30),
          ),
        ],
      ),
      body: Column(
        children: [
          // Hero Section
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Play today’s quiz and earn rewards!',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // Subject Tiles
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                SubjectTile(icon: Icons.calculate, title: 'Math'),
                SubjectTile(icon: Icons.science, title: 'Science'),
                SubjectTile(icon: Icons.public, title: 'General Knowledge'),
                SubjectTile(icon: Icons.computer, title: 'Computer Science'),
              ],
            ),
          ),

          // Mixed Quiz Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Navigate to Mixed Quiz
              },
              child: Text(
                'Mixed Quiz Challenge',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class SubjectTile extends StatelessWidget {
  final IconData icon;
  final String title;

  SubjectTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to quiz for this subject
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
