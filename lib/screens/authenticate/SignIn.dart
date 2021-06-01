import 'package:flutter/material.dart';
import 'package:plannus/util/PresetColors.dart';
import 'package:plannus/services/AuthService.dart';
import 'package:plannus/util/Validate.dart';
import 'package:plannus/elements/Loading.dart';
import 'package:plannus/elements/MyButtons.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field states
  String email = "";
  String password = "";

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
                    "Welcome back! Ready to make plans for your life?",
                    style: TextStyle(
                      fontSize: 36,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
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
                            icon: Icon(Icons.email),
                            hintText: 'Enter your email',
                            labelText: 'Email',
                          ),
                          onChanged: (value) {
                            setState(() => email = value);
                          },
                          validator: validator.validateEmail,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            hintText: 'Enter your password',
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            setState(() => password = value);
                          },
                          validator: validator.validatePassword,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: MyButtons.roundedBlue(
                      text: "Sign In",
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error =
                              "Sign in unsuccessful. Please check that your email and password are correct.";
                              loading = false;
                            });
                          } else {
                            Navigator.pop(context);
                            setState(() => error = "");
                          }
                        }
                      },
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
