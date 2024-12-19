import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

  Future<void> _fetchQuizData() async {
    try {
      DocumentSnapshot levelDoc = await _firestore.collection('quiz_zone')
          .doc('yRnV2VcqGqRuvBeCzGLi')
          .collection('levels').doc('1').get();

      if (levelDoc.exists) {
        setState(() {
          questions = List<Map<String, dynamic>>.from(levelDoc.get('questions'));
        });
      } else {
        print('Level 1 document does not exist');
      }
    } catch (e) {
      print('Error fetching quiz data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Quiz'),
      ),
      body: questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> question = questions[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question['question'] ?? 'No question available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...List<Widget>.from((question['options'] as List).map((option) {
                    return Text(option);
                  })),
                  SizedBox(height: 10),
                  Text(
                    'Correct Answer: ${question['correct_answer'] ?? 'No correct answer available'}',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
