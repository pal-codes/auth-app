import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makestories_interview/abstractions/database.dart';
import 'package:makestories_interview/abstractions/user.dart';
import 'package:makestories_interview/ui/login.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void updateData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String userId = user.uid;
    Map<String, dynamic> values = new Map<String, dynamic>();
    if (nameController.text != null && nameController.text.isNotEmpty)
      values["name"] = nameController.text;
    if (emailController.text != null && emailController.text.isNotEmpty)
      values["email"] = emailController.text;
    if (numberController.text != null && numberController.text.isNotEmpty)
      values["number"] = numberController.text;
    if (ageController.text.isEmpty != null && ageController.text.isNotEmpty)
      values["age"] = ageController.text;
    Firestore.instance
        .collection('users')
        .document(userId)
        .updateData(values)
        .catchError((e) => {
              if (e != null)
                {
                  Fluttertoast.showToast(
                      msg: e.toString(),
                      backgroundColor: Colors.white,
                      fontSize: 15,
                      gravity: ToastGravity.BOTTOM,
                      toastLength: Toast.LENGTH_SHORT,
                      textColor: Color.fromRGBO(9, 68, 93, 1))
                }
              else
                {
                  Fluttertoast.showToast(
                      msg: 'User Data updated successfully',
                      backgroundColor: Colors.white,
                      fontSize: 18,
                      gravity: ToastGravity.BOTTOM,
                      toastLength: Toast.LENGTH_SHORT,
                      textColor: Color.fromRGBO(9, 68, 93, 1))
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
        body: ListView(children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 30),
            alignment: Alignment.center,
            child: Text('About you',
                style: GoogleFonts.workSans(
                    color: Color.fromRGBO(9, 68, 93, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.w600)),
          ),
          StreamBuilder<User>(
              stream: DatabaseService(uid: user.uid).userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.only(top: 250),
                    alignment: Alignment.center,
                    child: Text('Getting data..',
                        style: GoogleFonts.workSans(
                            color: Color.fromRGBO(9, 68, 93, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(12),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 50),
                                child: TextFormField(
                                  // initialValue: snapshot.data['name'] ?? 'Enter name',
                                  controller: nameController,
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.workSans(
                                        fontSize: 18,
                                        color: Color.fromRGBO(9, 68, 93, 1),
                                      ),
                                      labelText: snapshot.data.name ??
                                          'Enter your Name',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  // initialValue: snapshot.data['email'] ?? 'Enter email',
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.workSans(
                                        fontSize: 18,
                                        color: Color.fromRGBO(9, 68, 93, 1),
                                      ),
                                      labelText: snapshot.data.email ??
                                          'Enter your email',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  // initialValue: snapshot.data['number'] ?? 'Enter email',
                                  controller: numberController,
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.workSans(
                                        fontSize: 18,
                                        color: Color.fromRGBO(9, 68, 93, 1),
                                      ),
                                      labelText: snapshot.data.number ??
                                          'Enter your phone number',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  // initialValue: snapshot.data['age'] ?? 'Enter email',
                                  controller: ageController,
                                  decoration: InputDecoration(
                                      labelStyle: GoogleFonts.workSans(
                                        fontSize: 18,
                                        color: Color.fromRGBO(9, 68, 93, 1),
                                      ),
                                      labelText:
                                          snapshot.data.age ?? 'Enter your age',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 80, left: 20, right: 20, bottom: 10),
                                width: 350,
                                height: 60,
                                child: RaisedButton(
                                  onPressed: updateData,
                                  color: Colors.white,
                                  elevation: 0,
                                  child: Text(
                                    'Update Info',
                                    style: GoogleFonts.workSans(
                                        color: Color.fromRGBO(9, 68, 93, 1),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: Color.fromRGBO(9, 68, 93, 1),
                                          width: 3)),
                                ),
                              )
                            ])),
                  );
                }
              })
        ]),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Logout',
              style: GoogleFonts.workSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              )),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Color.fromRGBO(9, 68, 93, 1),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()),
                (route) => false);
          },
        ));
  }
}
