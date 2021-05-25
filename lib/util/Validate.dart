/// provides functions for form validators
class Validate {

  String validateUsername(String username) {
    return username.isEmpty ? "Username must not be empty" : null;
  }

  String validateEmail(String email) {
    return email.isEmpty ? "Email must not be empty" : null;
  }

  String validatePassword(String password) {
    Pattern pattern =
        r'^(?=.{8,}$)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?\W).*$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(password))
      return "Password must have at least 8 characters, 1 uppercase letter, 1 lowercase letter and 1 special character.";
    else {
      return null;
    }
  }
}