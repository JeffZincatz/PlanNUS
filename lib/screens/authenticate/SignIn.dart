import 'package:flutter/material.dart';
import 'package:plannus/util/PresetColors.dart';
import 'package:plannus/services/AuthService.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  // text field states
  String email = "";
  String password = "";

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
                  "Welcome back! Ready to make plans for your life?",
                  style: TextStyle(
                    fontSize: 36,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
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
                  obscureText: true,
                  onChanged: (value) {
                    setState(() => password = value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextButton(
                    onPressed: () async {
                      // Navigator.pushNamed(context, '/home');
                      // print(email);
                      // print(password);
                    },
                    child: Text(
                      "Sign In",
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

                /*
                Padding(
              padding: const EdgeInsets.all(12),
              child: TextButton(
                onPressed: () async {
                  dynamic user = await _auth.signInAnon();
                  if (user == null) {
                    print("Error signing in.");
                  } else {
                    print("Signed in: " + user.uid);
                    Navigator.pop(context);
                  }
                },

                child: Text(
                  "Sign In Anonymously",
                  style: TextStyle(
                    fontSize: 24,
                    color: PresetColors.blue,
                  ),
                ),
                style: TextButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
                */

              ],
            ),
          ),
        ),
      ),
    );
  }
}
