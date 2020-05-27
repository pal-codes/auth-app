import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makestories_interview/ui/home.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String nameValidator(String value) {
    if (value.isEmpty) {
      return 'Enter your name';
    }
    return null;
  }

  String emailValidator(String value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Please enter proper email';
    }
    return null;
  }

  String numberValidator(String value) {
    if (value.isEmpty) {
      return 'Enter your phone number';
    } else {
      return null;
    }
  }

  String passwordValidator(String value) {
    if (value.length <= 6) {
      return 'Enter more than 6 characters';
    }
    return null;
  }

  void signUp() async {
    bool isValidated = _formKey.currentState.validate();
    if (isValidated == true) {
      final FirebaseUser user = (await auth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text))
          .user;
      String userId = user.uid;

      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));

      await Firestore.instance.collection('users').document(userId).setData({
        'name': nameController.text,
        'email': emailController.text,
        'number': numberController.text,
        'age': ageController.text,
        'created': FieldValue.serverTimestamp()
      }).then((a) {
        print('USER CREATED');
      });
    } else {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30, bottom: 20),
            padding: EdgeInsets.all(20),
            child: Text(
              'we would like to know you',
              style:
                  GoogleFonts.lato(fontSize: 30, fontWeight: FontWeight.w300),
            )),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 40),
                  child: TextFormField(
                    controller: nameController,
                    validator: nameValidator,
                    keyboardType: TextInputType.text,
                    cursorColor: Color.fromRGBO(70, 206, 206, 1),
                    decoration: InputDecoration(
                        labelText: 'Enter your name',
                        labelStyle: GoogleFonts.lato(
                            fontSize: 12, fontWeight: FontWeight.w300),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(70, 206, 206, 1),
                            )),
                        focusColor: Color.fromRGBO(70, 206, 206, 1),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color.fromRGBO(70, 206, 206, 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(),
                        )),
                  )),
              Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: emailController,
                    validator: emailValidator,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Color.fromRGBO(70, 206, 206, 1),
                    decoration: InputDecoration(
                        labelText: 'Enter your email',
                        labelStyle: GoogleFonts.lato(
                            fontSize: 12, fontWeight: FontWeight.w300),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(70, 206, 206, 1),
                            )),
                        focusColor: Color.fromRGBO(70, 206, 206, 1),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Color.fromRGBO(70, 206, 206, 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(),
                        )),
                  )),
              Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: numberController,
                    validator: numberValidator,
                    keyboardType: TextInputType.number,
                    cursorColor: Color.fromRGBO(70, 206, 206, 1),
                    decoration: InputDecoration(
                        labelText: 'Enter your phone number',
                        labelStyle: GoogleFonts.lato(
                            fontSize: 12, fontWeight: FontWeight.w300),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(70, 206, 206, 1),
                            )),
                        focusColor: Color.fromRGBO(70, 206, 206, 1),
                        prefixIcon: Icon(
                          Icons.call,
                          color: Color.fromRGBO(70, 206, 206, 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(),
                        )),
                  )),
              Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    cursorColor: Color.fromRGBO(70, 206, 206, 1),
                    decoration: InputDecoration(
                        labelText: 'Enter your age',
                        labelStyle: GoogleFonts.lato(
                            fontSize: 12, fontWeight: FontWeight.w300),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(70, 206, 206, 1),
                            )),
                        focusColor: Color.fromRGBO(70, 206, 206, 1),
                        prefixIcon: Icon(
                          Icons.assignment_turned_in,
                          color: Color.fromRGBO(70, 206, 206, 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(),
                        )),
                  )),
              Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: passwordController,
                    validator: passwordValidator,
                    keyboardType: TextInputType.text,
                    cursorColor: Color.fromRGBO(70, 206, 206, 1),
                    decoration: InputDecoration(
                        labelText: 'Enter a new password',
                        labelStyle: GoogleFonts.lato(
                            fontSize: 12, fontWeight: FontWeight.w300),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(70, 206, 206, 1),
                            )),
                        focusColor: Color.fromRGBO(70, 206, 206, 1),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Color.fromRGBO(70, 206, 206, 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(),
                        )),
                  )),
              Container(
                margin:
                    EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
                width: 300,
                height: 60,
                child: RaisedButton(
                  onPressed: signUp,
                  color: Colors.white,
                  elevation: 0,
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.lato(
                        fontSize: 30, fontWeight: FontWeight.w400),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: Color.fromRGBO(70, 206, 206, 1), width: 3)),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    numberController.dispose();
    ageController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}