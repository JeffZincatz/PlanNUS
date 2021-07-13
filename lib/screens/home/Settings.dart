import 'package:flutter/material.dart';
import 'package:planaholic/elements/MyButtons.dart';
import 'package:planaholic/services/AuthService.dart';
import 'package:planaholic/services/DbService.dart';
import 'package:planaholic/util/PresetColors.dart';
import 'package:planaholic/util/Validate.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final _formKey = GlobalKey<FormState>();

    AuthService _auth = new AuthService();
    DbService _db = new DbService();

    // Text field changes
    String passwordOld = "";
    String password_1 = "";
    String password_2 = "";

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings,
                    color: PresetColors.blue,
                  ),
                  SizedBox(
                    width: screenWidth * 0.01,
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(
                        fontSize: screenHeight * 0.04,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: PresetColors.blue,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Account",
                    style: TextStyle(
                        fontSize: screenHeight * 0.038,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(
                height: screenHeight * 0.02,
                thickness: 2,
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              buildSettingOptions(
                  context: context,
                  title: "Change password",
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Change Password"),
                            scrollable: true,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        key: ValueKey("enter-old-password"),
                                        decoration: InputDecoration(
                                          icon: Icon(Icons.lock),
                                          hintText: 'Enter old password',
                                          labelText: 'Old Password',
                                          errorMaxLines: 3,
                                        ),
                                        obscureText: true,
                                        onChanged: (value) {
                                          setState(() => passwordOld = value);
                                        },
                                        validator: Validate().validatePassword,
                                      ),
                                      TextFormField(
                                        key: ValueKey("change-new-password"),
                                        decoration: InputDecoration(
                                          icon: Icon(Icons.lock),
                                          hintText: 'Enter new password',
                                          labelText: 'New Password',
                                          errorMaxLines: 3,
                                        ),
                                        validator: Validate().validatePassword,
                                        obscureText: true,
                                        onChanged: (value) {
                                          setState(() => password_1 = value);
                                        },
                                      ),
                                      TextFormField(
                                        key: ValueKey("repeat-new-password"),
                                        decoration: InputDecoration(
                                          icon: Icon(Icons.lock),
                                          hintText: 'Repeat new password',
                                          labelText: 'Repeat New Password',
                                        ),
                                        obscureText: true,
                                        onChanged: (value) {
                                          setState(() => password_2 = value);
                                        },
                                        validator: (value) =>
                                            value != password_1
                                                ? "Passwords do not match"
                                                : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  key: ValueKey(
                                      "confirm-change-password-button"),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      dynamic result = await _auth
                                          .signInWithEmailAndPassword(
                                              await _db.getEmail(),
                                              passwordOld);

                                      if (result != null) {
                                        _auth
                                            .changePassword(
                                                password: password_1)
                                            .then((_) {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      "Your password has been changed successfully."),
                                                  actions: [
                                                    TextButton(
                                                      child: Text("Confirm"),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                  ],
                                                );
                                              });
                                        });
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Failed to change password."),
                                              content: Text(
                                                  "Your old password could be incorrect."),
                                              actions: [
                                                TextButton(
                                                  child: Text("Ok"),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: Text("Confirm")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel")),
                            ],
                          );
                        });
                  }),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Row(
                children: [
                  Icon(
                    Icons.volume_up_outlined,
                    color: PresetColors.blue,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Notifications",
                    style: TextStyle(
                        fontSize: screenHeight * 0.038,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(
                height: screenHeight * 0.02,
                thickness: 2,
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              buildSettingOptions(
                  context: context, title: "[Placeholder]", onTap: () {}),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Container(
                  width: screenWidth * 0.7,
                  child: MyButtons.roundedRed(
                    key: ValueKey("sign-out-button"),
                    text: "Sign Out",
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screenHeight * 0.036,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildSettingOptions(
      {@required BuildContext context,
      @required String title,
      @required Function onTap}) {
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screenHeight * 0.036,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
