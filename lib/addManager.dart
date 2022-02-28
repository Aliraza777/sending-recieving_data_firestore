import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sendtest/showManager.dart';

class AddManager extends StatefulWidget {
  const AddManager({Key? key}) : super(key: key);

  @override
  _AddManagerState createState() => _AddManagerState();
}

class _AddManagerState extends State<AddManager> {
  String? value;
  @override
  void initState() {
    super.initState();
  }

  // final Future<FirebaseApp> db = Firebase.initializeApp();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  // late String selectedservice;
  final formkey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();

  List<String> services = [
    "Transport",
    "Inventory",
    "Despensery",
    "Carpenter",
    "Electrical",
    "Plumber",
    "Generator Technician",
    "Mason",
    "AC Technician",
    "Drainage",
    "Cleaning",
    "Cylinder Replacement"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Manager"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: name,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  // validator: (value) =>
                  //     value != null ? "Enter valid full name" : null,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: email,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  // validator: (value) =>
                  //     value != null ? "Enter correct email" : null,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: phoneNo,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  // validator: (value) =>
                  //     value != null ? "Enter correct phone number" : null,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButton<String>(
                    elevation: 16,
                    hint: Text("Services"),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    iconSize: 36,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    isExpanded: true,
                    value: value,
                    items: services.map(buildMenuItem).toList(),
                    onChanged: (value) => setState(() {
                      this.value = value;
                    }),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                    onPressed: () async {
                      add();
                    },
                    child: Text("Add Manager"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontSize: 15),
        ),
      );
  Future add() async {
    final manager = _database.child('/managers');
    final isValid = formkey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      final map = <String, dynamic>{
        'name': name.text,
        'email': email.text,
        'phoneNo': phoneNo.text,
        'services': value.toString(),
      };
      await manager.push().set(map);
      print("data added");
    } catch (e) {
      print("Error $e");
    }
    print("complain added");
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => ShowManagers()));
  }
}
