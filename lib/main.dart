import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sendtest/showManager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const TestSend(),
      home: ShowManagers(),
    );
  }
}

class TestSend extends StatefulWidget {
  const TestSend({Key? key}) : super(key: key);

  @override
  _TestSendState createState() => _TestSendState();
}

class _TestSendState extends State<TestSend> {
  final _database = FirebaseDatabase.instance.ref();
  String _displayText = 'Results go here!';
  late StreamSubscription _dailyReport;
  @override
  void initState() {
    super.initState();
    _activateListners();
  }

  Future<void> _activateListners() async {
    _dailyReport = _database.child('manager').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final name = data['name'] as String;
      final email = data['email'] as String;
      final phone = data['phone'] as String;
      setState(() {
        _displayText =
            "Manager name is  : $name ,\n his email is : $email and his phone No is : $phone";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final manager = database.child('/manager');
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Send"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  try {
                    final order = <String, dynamic>{
                      'Worker name': 'majid',
                      'phone': 034177789971,
                      'Complain id': '9s8ja9sjsss',
                      'Time': DateTime.now().millisecondsSinceEpoch,
                    };
                    // await database.child('/Assignments').push().set(order);
                    // await manager.child('name').set('Ali Wahlah');
                    print("data written");
                  } catch (e) {
                    print("you got an error $e");
                  }
                },
                child: Text("Send Data")),
            SizedBox(height: 50.0),
            Text(_displayText),
          ],
        ),
      ),
    );
  }
}
