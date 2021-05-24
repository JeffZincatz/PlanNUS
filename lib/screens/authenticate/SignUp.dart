import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plannus/services/AuthService.dart';
import 'package:plannus/util/PresetColors.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // text field changes
  String username = "";
  String email = "";
  String password_1 = "";
  String password_2 = "";

  String error = "";

  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PresetColors.background,
      body: SafeArea(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  "Get start with us today and end your procrastination!",
                  style: TextStyle(
                    fontSize: 36,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      error,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter your username',
                          labelText: 'Username',
                        ),
                        validator: (value) =>
                            value.isEmpty ? "Username must not be empty" : null,
                        onChanged: (value) {
                          setState(() => username = value);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          hintText: 'Enter your email',
                          labelText: 'Email',
                        ),
                        validator: (value) =>
                            value.isEmpty ? "Email must not be empty" : null,
                        onChanged: (value) {
                          setState(() => email = value);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Enter your password',
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          Pattern pattern =
                              r'^(?=.{8,}$)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?\W).*$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value))
                            return "Password must have at least 8 characters, one uppercase letter, one lowercase letter and one special character. ";
                          else {
                            return null;
                          }
                        },
                        obscureText: true,
                        onChanged: (value) {
                          setState(() => password_1 = value);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Repeat your password',
                          labelText: 'Re-enter Password',
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() => password_2 = value);
                        },
                        validator: (value) {
                          if (value != password_1) {
                            return "Passwords do not match";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextButton(
                    onPressed: () async {
                      // Navigator.pushNamed(context, '/home');

                      if (_formKey.currentState.validate()) {
                        // print(username);
                        // print(email);
                        // print(password_1);
                        dynamic result = await _auth.signUpWithEmailAndPassword(
                            email, password_1);
                        if (result == null) {
                          setState(() => error =
                              "Sign up unsuccessful. Please check that your email is valid.");
                        } else {
                          Navigator.pop(context);
                          setState(() => error = "");
                        }
                      }
                    },
                    child: Text(
                      "Get Started!",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: PresetColors.blueAccent,
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
