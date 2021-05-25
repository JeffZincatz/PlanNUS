import 'package:flutter/material.dart';
import 'package:plannus/util/PresetColors.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PresetColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/notebook-logo.png",
                  scale: 20,
                ),
                Image.asset(
                  "assets/images/PlanNUS.png",
                  scale: 2,
                ),
              ],
            ),
            Column(
              children: [
                TextButton.icon(
                  onPressed: (){Navigator.pushNamed(context, '/signin');},
                  icon: Icon(
                    Icons.login_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: PresetColors.blueAccent,
                    minimumSize: Size(200, 50),
                    padding: EdgeInsets.all(5),
                  ),
                ),
                SizedBox(height: 30,),
                TextButton.icon(
                  onPressed: (){Navigator.pushNamed(context, '/signup');},
                  icon: Icon(
                    Icons.account_box,
                    color: PresetColors.blueAccent,
                  ),
                  label: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: PresetColors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(200, 50),
                    padding: EdgeInsets.all(5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
