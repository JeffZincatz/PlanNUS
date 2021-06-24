import 'package:flutter_test/flutter_test.dart';
import 'package:planaholic/util/Validate.dart';

void main() {
  group("validateUsername", () {
    test("Empty string: Username must not be empty", () {
      // Arrange
      String empty = "";

      // Act
      String actual = Validate().validateUsername(empty);

      // Assert
      expect(actual, "Username must not be empty");
    });

    test("Any none empty string: null", () {
      // Arrange
      String s1 = " ";
      String s2 = "Jeff";
      String s3 =  "1";
      String s4 = "|";

      // Act
      String a1 = Validate().validateUsername(s1);
      String a2 = Validate().validateUsername(s2);
      String a3 = Validate().validateUsername(s3);
      String a4 = Validate().validateUsername(s4);

      // Assert
      expect(a1, null);
      expect(a2, null);
      expect(a3, null);
      expect(a4, null);
    });
  });

  group("validateEmail", () {
    // Currently, email is not validated using regex, only checked if empty
    // however, Firebase Auth would use email to sign up & send verification email
    // hence only proper email would pass sign up.

    test("Empty string: Email must not be empty", () {
      // Arrange
      String empty = "";

      // Act
      String actual = Validate().validateEmail(empty);

      // Assert
      expect(actual, "Email must not be empty");
    });

    test("Any none empty string: null", () {
      // Arrange
      String s1 = " ";
      String s2 = "jeffzincatz@gmail.com";
      String s3 =  "random@email";
      String s4 = "|";

      // Act
      String a1 = Validate().validateEmail(s1);
      String a2 = Validate().validateEmail(s2);
      String a3 = Validate().validateEmail(s3);
      String a4 = Validate().validateEmail(s4);

      // Assert
      expect(a1, null);
      expect(a2, null);
      expect(a3, null);
      expect(a4, null);
    });
  });

  group("validatePassword", () {
    test("Weak passwords: Password must have at least 8 characters, 1 uppercase letter, 1 lowercase letter and 1 special character.", () {
      // Arrange
      String empty = "";
      String w1 = "onlyalphabets";
      String w2 = "14159265358979323846";
      String w3 = "alphabetsandnumbers1234";
      String w4 = "UPPERlowercases";
      String w5 = "NoSpecialCharacter1234";
      String w6 = "Short1.";

      // Act
      String ae = Validate().validatePassword(empty);
      String a1 = Validate().validatePassword(w1);
      String a2 = Validate().validatePassword(w2);
      String a3 = Validate().validatePassword(w3);
      String a4 = Validate().validatePassword(w4);
      String a5 = Validate().validatePassword(w5);
      String a6 = Validate().validatePassword(w6);


      // Assert
      String invalidMessage = "Password must have at least 8 characters, 1 uppercase letter, 1 lowercase letter and 1 special character.";
      expect(ae, invalidMessage);
      expect(a1, invalidMessage);
      expect(a2, invalidMessage);
      expect(a3, invalidMessage);
      expect(a4, invalidMessage);
      expect(a5, invalidMessage);
      expect(a6, invalidMessage);
    });

    test("Strong passwords: null", () {
      // Arrange
      String s1 = "Test1234.";
      String s2 = "Jeff77777,";
      String s3 =  "?.Aa999z";
      String s4 = "|...Eee1";

      // Act
      String a1 = Validate().validatePassword(s1);
      String a2 = Validate().validatePassword(s2);
      String a3 = Validate().validatePassword(s3);
      String a4 = Validate().validatePassword(s4);

      // Assert
      expect(a1, null);
      expect(a2, null);
      expect(a3, null);
      expect(a4, null);
    });
  });
}