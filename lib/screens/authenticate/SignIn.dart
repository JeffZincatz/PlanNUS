import 'package:flutter/material.dart';
import 'package:planaholic/screens/authenticate/ResetPassword.dart';
import 'package:planaholic/util/PresetColors.dart';
import 'package:planaholic/services/AuthService.dart';
import 'package:planaholic/util/Validate.dart';
import 'package:planaholic/elements/Loading.dart';
import 'package:planaholic/elements/MyButtons.dart';
import 'Verifying.dart';
import 'ResetPassword.dart';

/// Sign in page
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
        body: GestureDetector(
          onTap: () {
            // un-focus text form field when tapped outside
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
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
                            key: ValueKey("sign-in-email-form-field"),
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
                            key: ValueKey("sign-in-password-form-field"),
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: 'Enter your password',
                              labelText: 'Password',
                              errorMaxLines: 3,
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
                    TextButton(
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: PresetColors.blueAccent,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: MyButtons.roundedBlue(
                        key: ValueKey("sign-in-confirm-button"),
                        text: "Sign In",
                        onPressed: () async {
                          _auth.signOut();
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
                              print("Sign in result:\n" + result.toString());
                              Navigator.pop(context);
                              setState(() => error = "");
                              if (_auth.getCurrentUser() != null && !_auth.getCurrentUser().emailVerified) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Verifying()));
                              }
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
        ),
      );
  }
}
