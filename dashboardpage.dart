//dashboard page
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzy/redeem.dart';
import 'RewardedAdService.dart';

import 'quiz_zonef/QuizZonePage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'math_zonef/math_quiz.dart';

class DashboardPage extends StatefulWidget {
  final String? userName;
  final int? coinBalance;

  DashboardPage({
    this.userName,
    this.coinBalance,

  });

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Timer _timer;
  int keysCollected = 0;
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  final int keysRequired = 5;
  final RewardedAdService _rewardedAdService = RewardedAdService();

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    _rewardedAdService.loadRewardedAd();
    _fetchUserDataAndSetKeys();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _fetchUserDataAndSetKeys();
    });
  }



  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test Ad Unit ID
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          print('Failed to load rewarded ad: ${error.message}');
          setState(() {
            _isAdLoaded = false;
          });
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        setState(() {
          keysCollected += 1;
        });
        updateRewarded(keysCollected);
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

  Future<void> _fetchUserDataAndSetKeys() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      keysCollected = userDoc['rewarded'];
    });
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return {
      'coin_balance': userDoc['coin_balance'],
      'rewarded': userDoc['rewarded'],
    };
  }

  Future<void> updateRewarded(int newRewarded) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'rewarded': newRewarded});
  }

  void _addKey() {
    setState(() {
      keysCollected += 1;
    });

    updateRewarded(keysCollected);
  }

  Future<void> _openQuizZone() async {
    if (keysCollected >= keysRequired) {
      setState(() {
        keysCollected -= keysRequired;
      });

      updateRewarded(keysCollected);

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MathQuizPage()),
      );

      setState(() {});
    }
  }

  void _showRewardedAdAndAddKey() {
    _rewardedAdService.showRewardedAd(() {
      _addKey();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedAdService.dispose();
    _rewardedAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hello ${widget.userName ?? 'User'}', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              (widget.userName?.isNotEmpty ?? false) ? widget.userName![0].toUpperCase() : 'U',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            FutureBuilder<Map<String, dynamic>>(
              future: fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.amber),
                      Text('...', style: TextStyle(color: Colors.black)),
                      SizedBox(width: 10),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.amber),
                      Text('Error', style: TextStyle(color: Colors.black)),
                      SizedBox(width: 10),
                    ],
                  );
                } else {
                  final coinBalance = snapshot.data!['coin_balance'];
                  final rewarded = snapshot.data!['rewarded'];
                  keysCollected = rewarded;
                  return Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.amber),
                      Text('$coinBalance', style: TextStyle(color: Colors.black)),
                      SizedBox(width: 10),
                    ],
                  );
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    CustomCard(
                      title: "QUIZ ZONE",
                      icon: Icons.lightbulb,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizZonePage()),
                        );
                      },
                    ),
                    CustomCard(
                      title: "MATH QUIZ",
                      icon: Icons.calculate,
                      keyText: "${keysCollected}/${keysRequired}",
                      onTap: _openQuizZone,
                    ),
                    CustomCard(
                      title: "ONLINE PLAYER",
                      icon: Icons.person,
                      onTap: () {},
                    ),
                    CustomCard(
                      title: "DAILY QUIZ",
                      icon: Icons.event,
                      onTap: () {},
                    ),
                    CustomCard(
                      title: "GROUP PLAYER",
                      icon: Icons.people,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.pink,
                    child: const Icon(Icons.settings),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RedeemPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    icon: const Icon(Icons.card_giftcard_rounded, color: Colors.white),
                    label: const Text("Reward"),
                  ),
                  FloatingActionButton(
                    onPressed: _isAdLoaded ? _showRewardedAd : null,
                    backgroundColor: Colors.pink,
                    child: const Icon(Icons.ads_click),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String keyText;

  const CustomCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.keyText = "",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (keyText.isNotEmpty)
              Text(
                keyText,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzy/redeem.dart';
 // Make sure you have this imported

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      // UPDATED: Listen to Firestore updates in real-time
      stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text("Dashboard")),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>?;
        if (userData == null) {
          return Scaffold(
            appBar: AppBar(title: Text("Dashboard")),
            body: Center(child: Text("No user data found.")),
          );
        }

        int rewarded = userData['rewarded'] ?? 0; // UPDATED: Real-time value
        int coinBalance = userData['coin_balance'] ?? 0;

        return Scaffold(
          appBar: AppBar(
            title: Text("Dashboard"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rewarded: $rewarded",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  "Coin Balance: $coinBalance",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    // Navigate to Redeem Page
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RedeemPage()),
                    );
                    // No need to manually refresh due to StreamBuilder
                  },
                  child: Text("Redeem Rewards"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
*/