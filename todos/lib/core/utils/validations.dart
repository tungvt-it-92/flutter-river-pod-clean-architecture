import 'dart:async';

const moneyRegex = r'(?=.*?\d)^\$?(([1-9]\d{0,2})|\d+)?(\.\d{1,3})*?$';
const cardNumberRegex = r'^[0-9]{15,18}$';
const cvvRegex = r"^[0-9]{3,4}$";
const expiredDateRegex = r"^[0-9]{2}/[0-9]{4}$";
// const phoneNumberRegex =
//     r"^[+]{1}[1-9]{2}([0-9]+){9,}$|^0([0-9]+){9,}$|^([+]{0,1}([0-9]+-[0-9]+)+[0-9]+$|^[+]{0,1}([0-9]+ [0-9]+)+[0-9]+){9,}$";
const userNameRegex = ".+"; //r"^[a-zA-Z0-9_\\-\\.]+$";
const passwordRegex =
    r'^[a-zA-Z0-9\u0027\|\{\}@#$%^&+=*.,\-_!`\[\]";:<>?/\\]+$';
const searchPhoneRegex = r"^[0-9\\s]+$";
const residentIdRegex = r"^[0-9]{8,12}$";
const idCardRegex = r"^[0-9]{9,12}$";
const bankAccountRegex = r"^[0-9]{8,15}$";
const userIdInputRegex = r"^[a-zA-Z0-9]*$";
const onlyNumbersRegex = r'[^\d]';
const phoneNumberRegex = r'^\+?[1-9]{3}-?[0-9]{6,12}$';
const phoneNumberRegexContact = r'^(?:[+0]9)?[0-9]{10}$';
const phoneNumberRegexVietNamese =
    r'([\+84|84|0]+(3|5|7|8|9|1[2|6|8|9]))+([0-9]{8})\b';
const emailRegex =
    r'[a-zA-Z0-9\+\.\_\%\-]{1,256}\@[a-zA-Z0-9][a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25}){1,2}';
const passwordRegister = r'^[a-zA-Z0-9@#$%^&+=*.\-_]{6,}$';

typedef ValidatorFunction = bool Function(String, String?);

const int minLengthPassword = 6;
const int maxLengthPassword = 6;
const int maxLengthName = 256;

class Validators {
  validateMoneyTransformer(int currentAmount) {
    return StreamTransformer<String, bool>.fromHandlers(
        handleData: (money, sink) {
      RegExp regex = RegExp(moneyRegex);
      bool match = regex.hasMatch(money);
      String m = money;
      if (money.contains('.')) {
        m = m.replaceAll('.', '');
      } else if (money.contains(',')) {
        m = m.replaceAll(',', '');
      }
      bool check = int.parse(m) <= currentAmount;
      sink.add(match && check);
    });
  }

  final validatePasswordTransformer =
      StreamTransformer<String, bool>.fromHandlers(
          handleData: (password, sink) {
    RegExp regex = RegExp(passwordRegex);
    sink.add(regex.hasMatch(password));
  });

  final validatePhoneNumbTransformer =
      StreamTransformer<String, bool>.fromHandlers(
          handleData: (phoneNumb, sink) {
    sink.add(isPhoneNumberValid(phoneNumb));
  });

  final validateBillIdTransformer =
      StreamTransformer<String, bool>.fromHandlers(handleData: (billId, sink) {
    sink.add(billId.isNotEmpty);
  });

  final validateEmailTransformer =
      StreamTransformer<String, bool>.fromHandlers(handleData: (email, sink) {
    sink.add(email.isNotEmpty ? isEmailValid(email) : true);
  });

  final validateOTPCodeTransformer =
      StreamTransformer<String, bool>.fromHandlers(handleData: (otp, sink) {
    sink.add(otp.length == 4);
  });

  static bool isPasswordValid(String inputPassword, String? text) {
    RegExp regex = RegExp(passwordRegister);
    return regex.hasMatch(inputPassword);
  }

  static bool isPhoneNumberValid(String inputPhoneNumber) {
    RegExp regex = RegExp(phoneNumberRegexVietNamese);

    return regex.hasMatch(inputPhoneNumber);
  }

  static bool isPhoneNumberValidContact(String inputPhoneNumber) {
    RegExp regex = RegExp(phoneNumberRegexVietNamese);

    return regex.hasMatch(inputPhoneNumber);
  }

  static bool isEmailValid(String email) {
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  static bool isTheSameText(String password, String? passwordConfirm) {
    return password == passwordConfirm;
  }

  static bool isFullNameValid(String inputFullName, String? text) {
    return inputFullName.isNotEmpty;
  }

  static bool isIdCardValid(String idCard, String? text) {
    RegExp regex = RegExp(idCardRegex);
    return regex.hasMatch(idCard);
  }
}
