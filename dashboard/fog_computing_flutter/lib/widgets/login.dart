import 'package:admin/screens/dashboard/components/test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin/screens/main/components/account.dart';
import 'package:admin/utils/authentication.dart';
import 'package:admin/widgets/auth_dialog.dart';

import '../constants.dart';
import 'google_sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email, _password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Center(
        child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text(" Fog Computing Platform Log In/Sign Up", textAlign: TextAlign.center)),
            backgroundColor: secondaryColor,
          ),
          body: Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              // borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: 'Email'
                      ),
                      onChanged: (value) {
                        setState(() {
                          _email = value.trim();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Password'),
                      onChanged: (value) {
                        setState(() {
                          _password = value.trim();
                        });
                      },
                    ),

                  ),
                ),
                SizedBox(
                  width: 500,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:[
                        ElevatedButton(
                            child: Text('Log In'),
                            onPressed: (){
                              auth.signInWithEmailAndPassword(email: _email, password: _password).then((_){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Measurements()));
                              });

                            }),
                        ElevatedButton(
                          child: Text('Sign Up'),
                          onPressed: (){
                            auth.createUserWithEmailAndPassword(email: _email, password: _password).then((_){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Measurements()));
                            });

                          },
                        )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 100.0,
                    right: 100.0,
                  ),
                  // child: Container(
                  //   height: 1,
                  //   width: double.maxFinite,
                  //   color: Colors.red[200],
                  // ),
                ),
                SizedBox(height: 30),
                Center(child: GoogleButton()),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'By proceeding, you agree to our Terms of Use and confirm you have read our Privacy Policy.',
                    maxLines: 2,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle2!.color,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      // letterSpacing: 3,
                    ),
                  ),
                ),


              ],),
          ),
        ),
      ),
    );
  }
}