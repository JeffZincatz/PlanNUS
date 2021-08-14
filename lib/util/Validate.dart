/// A collection of form validator methods
class Validate {

  /// Validate if the [username] is non-empty
  String validateUsername(String username) {
    return username.isEmpty ? "Username must not be empty" : null;
  }

  /// Validate if the [email] is non-empty
  String validateEmail(String email) {
    return email.isEmpty ? "Email must not be empty" : null;
  }

  /// Validate if the [password] is strong
  ///
  /// A [password] is strong only if it is at least 8 characters long,
  /// contains at least 1 lowercase letter, 1 uppercase letter, 1 digit,
  /// and 1 special character.
  String validatePassword(String password) {
    Pattern pattern =
        r'^(?=.{8,}$)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[\W_]).*$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(password))
      return "Password must have at least 8 characters, 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.";
    else {
      return null;
    }
  }
}