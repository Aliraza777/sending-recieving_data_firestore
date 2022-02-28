import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sendtest/modalManager.dart';

class ShowManagers extends StatefulWidget {
  const ShowManagers({Key? key}) : super(key: key);

  @override
  _ShowManagersState createState() => _ShowManagersState();
}

class _ShowManagersState extends State<ShowManagers> {
  final _database = FirebaseDatabase.instance.ref();
  String _displayText = 'Results go here!';
  late StreamSubscription _dailyReport;
  final tileslist = {};
  String test = "";
  List<Managers> managers = [];
  void initState() {
    super.initState();
    getData();
    // _activateListners();
  }

  Future<void> _activateListners() async {
    final _managers = _database.child('/managers');
    _dailyReport = _managers.onValue.listen((event) {
      print(event.snapshot.value);
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final name = data['name'] as String;
      final email = data['email'] as String;
      final phone = data['phone'] as String;
      final services = data['services'] as String;
      setState(() {
        _displayText =
            "Manager name is  : $name ,\n his email is : $email and his phone No is : $phone  \n his services are $services";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Managers"),
      ),
      body: Center(
        child: Column(
          children: [
            // StreamBuilder(
            //   stream: _database.child('managers').orderByKey().onValue,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       // final mydata = (snapshot.data! as Event).snapshot.value as Map<dynamic, dynamic>;
            //       print(snapshot.data);
            //       //   mydata.forEach((key, value) {
            //       //     final nextmember = value as Map<dynamic, dynamic>;
            //       //     final memberTile = ListTile(
            //       //       title: Text(nextmember['name'] + '\n' + nextmember['email']),
            //       //       subtitle: Text(
            //       //           nextmember['phoneNo'] + '\n' + nextmember['services']),
            //       //     );
            //       //     tileslist.add(memberTile);
            //       //   });
            //     }
            //   },
            // ),
            Text(_displayText),
            Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: ListView.builder(
                    itemCount: managers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(managers[index].name +
                            "     " +
                            managers[index].services),
                        subtitle: Text(managers[index].email +
                            "   " +
                            managers[index].phoneNo),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future getData() async {
    final db = FirebaseDatabase.instance.ref().child('managers');
    final event = await db.once();
    final data = (event.snapshot.value) as Map<dynamic, dynamic>;
    data.forEach((key, value) {
      managers.add(Managers.toObject(value));
    });
    // test = managers.toString();
    // print(test);
    for (var i = 0; i < managers.length; i++) {
      tileslist['name'] = managers[i].name;
      tileslist['email'] = managers[i].email;
      tileslist['phoneNo'] = managers[i].phoneNo;
      tileslist['service'] = managers[i].services;
      print(tileslist);
    }
    // print(managers[0].name);
    // print(managers);
  }
}
