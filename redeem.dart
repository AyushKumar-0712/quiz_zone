
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RedeemPage extends StatefulWidget {
  @override
  _RedeemPageState createState() => _RedeemPageState();
}

class _RedeemPageState extends State<RedeemPage> {
  final TextEditingController _keyController = TextEditingController();
  int rewarded = 0;
  int coinBalance = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Fetch user data
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          rewarded = userDoc['rewarded'];
          coinBalance = userDoc['coin_balance'];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _redeemKeys() async {
    int keysToRedeem = int.tryParse(_keyController.text) ?? 0;

    if (keysToRedeem <= 0) {
      _showSnackBar('Enter a valid number of keys.');
      return;
    }

    if (keysToRedeem > rewarded) {
      _showSnackBar('You don’t have enough keys to redeem.');
      return;
    }

    try {
      // Calculate coins to add
      int coinsToAdd = keysToRedeem * 5;

      // Fetch user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update Firestore with a transaction
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (userSnapshot.exists) {
          int currentRewarded = userSnapshot['rewarded'];
          int currentCoinBalance = userSnapshot['coin_balance'];

          // Ensure the user still has enough keys
          if (keysToRedeem > currentRewarded) {
            throw Exception('Not enough keys to redeem.');
          }

          // Update Firestore
          transaction.update(userRef, {
            'rewarded': currentRewarded - keysToRedeem,
            'coin_balance': currentCoinBalance + coinsToAdd,
          });

          // Update UI locally
          setState(() {
            rewarded = currentRewarded - keysToRedeem;
            coinBalance = currentCoinBalance + coinsToAdd;
          });
        }
      });

      _showSnackBar(
          'Successfully redeemed $keysToRedeem keys for $coinsToAdd coins!');
      _keyController.clear();

      // Refresh the dashboard page
      Navigator.pop(context, {'rewarded': rewarded, 'coinBalance': coinBalance});
    } catch (e) {
      print('Error during redemption: $e');
      _showSnackBar('Something went wrong. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redeem Keys'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rewarded: $rewarded keys', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Coin Balance: $coinBalance', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('1 Rewarded Key = 5 Coin'),
            TextField(
              controller: _keyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter keys to convert',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _redeemKeys,
              child: Text('Convert to Coins'),
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

class RedeemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    Future<void> redeemReward() async {
      DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(userId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);

        if (snapshot.exists) {
          int currentRewarded = snapshot['rewarded'] ?? 0;
          int currentCoinBalance = snapshot['coin_balance'] ?? 0;

          transaction.update(userDoc, {
            'rewarded': currentRewarded + 1, // Example reward increment
            'coin_balance': currentCoinBalance - 10, // Example coin deduction
          });
        }
      });

      Navigator.pop(context); // Navigate back to Dashboard Page
    }

    return Scaffold(
      appBar: AppBar(title: Text("Redeem Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: redeemReward,
          child: Text("Redeem Reward"),
        ),
      ),
    );
  }
}
*/