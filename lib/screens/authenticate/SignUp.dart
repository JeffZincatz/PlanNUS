import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plannus/elements/MyButtons.dart';
import 'package:plannus/services/AuthService.dart';
import 'package:plannus/elements/Loading.dart';
import 'package:plannus/util/PresetColors.dart';
import 'package:plannus/util/Validate.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field changes
  String username = "";
  String email = "";
  String password_1 = "";
  String password_2 = "";

  String error = "";
  bool loading = false;

  Validate validator = new Validate();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(backgroundColor: PresetColors.blueAccent),
            backgroundColor: PresetColors.background,
            body: SafeArea(
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        "Get started with us today and end your procrastination!",
                        style: TextStyle(
                          fontSize: 36,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        // display sign up error
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Center(
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
                              validator: validator.validateUsername,
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
                              validator: validator.validateEmail,
                              onChanged: (value) {
                                setState(() => email = value);
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                hintText: 'Enter your password',
                                labelText: 'Password',
                                errorMaxLines: 3,
                              ),
                              validator: validator.validatePassword,
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
                              validator: (value) => value != password_1
                                  ? "Passwords do not match"
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: MyButtons.roundedBlue(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                await _auth.signUpWithEmailAndPassword(
                                    username, email, password_1);
                                if (result == null) {
                                  setState(() {
                                    error =
                                    "Sign up unsuccessful. Please check that your email is valid.";
                                    loading = false;
                                  });
                                } else {
                                  User user = _auth.getCurrentUser();
                                  await user.sendEmailVerification().then((_) {
                                    Navigator.pop(context);
                                    setState(() => error = "");
                                  });
                                }
                              }
                            },
                            text: "Get Started!",
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
