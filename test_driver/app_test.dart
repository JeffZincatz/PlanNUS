// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  /// Integration testing to open Planaholic
  group('Planaholic', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    /// Integration testing to test the authentication
    group("Authenticate", () {
      // Authenticate
      final signInButton = find.byValueKey("sign-in-button");
      final signUpButton = find.byValueKey("sign-up-button");
      test("Sign in with email verified user", () async {
        // go to SignIn page
        await driver.tap(signInButton);

        // find widgets
        final emailField = find.byValueKey("sign-in-email-form-field");
        final passwordField = find.byValueKey("sign-in-password-form-field");
        final signInConfirmButton = find.byValueKey("sign-in-confirm-button");

        // enter email
        await driver.tap(emailField);
        await driver.enterText("jeffzincatz@gmail.com");

        // enter password
        await driver.tap(passwordField);
        await driver.enterText("Test1234.");

        // confirm sign in
        await driver.tap(signInConfirmButton);

        // await to go to home screen
        await driver.waitFor(find.text("Upcoming Activities"));

        // go to profile page and sign out
        final profilePage = find.text("My Profile");
        await driver.tap(profilePage);

        final signOutButton = find.byValueKey("sign-out-button");
        await driver.scrollUntilVisible(
          find.byType("ListView"),
          signOutButton,
          dyScroll: -500.0,
        );
        await driver.tap(signOutButton);
      });

      test("Sign in with unverified user", () async {
        // go to SignIn page
        await driver.tap(signInButton);

        // find widgets
        final emailField = find.byValueKey("sign-in-email-form-field");
        final passwordField = find.byValueKey("sign-in-password-form-field");
        final signInConfirmButton = find.byValueKey("sign-in-confirm-button");

        // enter email
        await driver.tap(emailField);
        await driver.enterText("random@email.com");

        // enter password
        await driver.tap(passwordField);
        await driver.enterText("Test1234.");

        // confirm sign in
        await driver.tap(signInConfirmButton);

        // await to go to home screen
        await driver.waitFor(find.text(
            "Almost there!\nGo check your email and verify before you log in!"));

        final goBackButton = find.byValueKey("verifying-go-back-button");
        await driver.tap(goBackButton);
        await driver.waitFor(find.byValueKey("sign-in-button"));
      });

      // Every time, this test tries to sign up a fake user,
      // using the same email. Please delete the user from
      // FirebaseAuth & Firestore afterwards.
      test("Sign up with valid email", () async {
        // go to SignUp page
        await driver.tap(signUpButton);

        // find widgets
        final usernameField = find.byValueKey("sign-up-username");
        final emailField = find.byValueKey("sign-up-email");
        final passwordField = find.byValueKey("sign-up-password");
        final repeatPasswordField = find.byValueKey("sign-up-repeat-password");
        final signUpConfirmButton = find.byValueKey("sign-up-confirm-button");

        // enter username
        await driver.tap(usernameField);
        await driver.enterText("New Testing User");

        // enter email
        await driver.tap(emailField);
        await driver.enterText("newtestinguser@fakeemail.com");

        // enter password
        await driver.tap(passwordField);
        await driver.enterText("Test1234.");

        // re-enter password
        await driver.tap(repeatPasswordField);
        await driver.enterText("Test1234.");

        // confirm sign in
        await driver.tap(signUpConfirmButton);

        // await for verification screen
        final goBackButton = find.byValueKey("verifying-go-back-button");
        await driver.tap(goBackButton);

        // await to go back to authenticate screen
        await driver.tap(find.pageBack());
        await driver.waitFor(signUpButton);
      });

      test("Sign up with invalid email", () async {
        // go to SignUp page
        await driver.tap(signUpButton);

        // find widgets
        final usernameField = find.byValueKey("sign-up-username");
        final emailField = find.byValueKey("sign-up-email");
        final passwordField = find.byValueKey("sign-up-password");
        final repeatPasswordField = find.byValueKey("sign-up-repeat-password");
        final signUpConfirmButton = find.byValueKey("sign-up-confirm-button");

        // enter username
        await driver.tap(usernameField);
        await driver.enterText("New Testing User");

        // enter email
        await driver.tap(emailField);
        await driver.enterText("invalidEmailFormat.com");

        // enter password
        await driver.tap(passwordField);
        await driver.enterText("Test1234.");

        // re-enter password
        await driver.tap(repeatPasswordField);
        await driver.enterText("Test1234.");

        // confirm sign in
        await driver.tap(signUpConfirmButton);

        // await for error message
        final errorMessage = find.text("Sign up unsuccessful. Please check that your email is valid.");
        await driver.waitFor(errorMessage);

        // await to go back to authenticate screen
        await driver.tap(find.pageBack());
        await driver.waitFor(signUpButton);
      });

      test("Re-send verification email", () async {
        // go to SignIn page
        await driver.tap(signInButton);

        // find widgets
        final emailField = find.byValueKey("sign-in-email-form-field");
        final passwordField = find.byValueKey("sign-in-password-form-field");
        final signInConfirmButton = find.byValueKey("sign-in-confirm-button");

        // enter email
        await driver.tap(emailField);
        await driver.enterText("random@email.com");

        // enter password
        await driver.tap(passwordField);
        await driver.enterText("Test1234.");

        // confirm sign in
        await driver.tap(signInConfirmButton);

        // await for verification screen
        await driver.waitFor(find.text(
            "Almost there!\nGo check your email and verify before you log in!"));

        // resend verification email
        final resendVerificationEmailButton = find.byValueKey("verifying-resend-verification-email");
        await driver.tap(resendVerificationEmailButton);

        // await to go back to authenticate screen
        await driver.waitFor(signInButton);
      });
    });

    /// Integration testing for changing username and sharing
    group("Functionalities", () {
      // Authenticate first
      final signInButton = find.byValueKey("sign-in-button");

      test("Change username", () async {
        // go to SignIn page
        await driver.tap(signInButton);

        // find widgets
        final emailField = find.byValueKey("sign-in-email-form-field");
        final passwordField = find.byValueKey("sign-in-password-form-field");
        final signInConfirmButton = find.byValueKey("sign-in-confirm-button");

        // enter email
        await driver.tap(emailField);
        await driver.enterText("jeffzincatz@gmail.com");

        // enter password
        await driver.tap(passwordField);
        await driver.enterText("Test1234.");

        // confirm sign in
        await driver.tap(signInConfirmButton);

        // await to go to home screen
        await driver.waitFor(find.text("Upcoming Activities"));

        // go to profile page
        final profilePage = find.text("My Profile");
        await driver.tap(profilePage);

        final changeName = find.byValueKey("changeNameIcon");
        await driver.tap(changeName);

        final field = find.byValueKey("nameField");
        await driver.tap(field);

        await driver.enterText("JeffZincatzEdited");
        final finalised = find.byValueKey("finalised");

        await driver.tap(finalised);

        await driver.tap(find.text("Home"));
      });

      test("Sharing", () async {
        await driver.tap(find.text("Achievements"));
        await driver.tap(find.text("Get started"));

        await driver.tap(find.byValueKey("badgeShareTotalTwitter"));
      });

    });
  });
}
