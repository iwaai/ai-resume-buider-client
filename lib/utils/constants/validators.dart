String? validateMobile(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your mobile number.';
  } else if (value.length < 14) {
    return 'Please enter valid length';
  }
  //  else if (!regExp.hasMatch(value)) {
  //   return 'Please enter valid mobile number';
  // }
  return null;
}

String? validateBirthday(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter birthday';
  } else if (value.length < 14) {
    return 'Please enter valid length';
  }
  return null;
}

// String? validateName(String? value) {
//   bool isValidName(String value) {
//     const String pattern = r'^[a-zA-Z\s]+$';
//     final regExp = RegExp(pattern);
//     return regExp.hasMatch(value);
//   }

//   if (value == null || value.isEmpty) {
//     return 'Please enter your name';
//   } else if (!isValidName(value)) {
//     return 'Please enter valid name without any number or special characters';
//   }♠
//   return null;
// }

String? validateName(String? value) {
  // bool isValidName(String value) {
  //   const String pattern = r"^[a-zA-Z][a-zA-Z\s'-]*$";
  //   final regExp = RegExp(pattern);
  //   return regExp.hasMatch(value);
  // }

  if (value == null || value.trim().isEmpty) {
    return 'Please enter your name';
  }

  if (value.trim().length < 3) {
    return 'Please enter a valid name';
  }

  return null;
}

String? validateEmail(String? email) {
  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  if (email == null || email.isEmpty) {
    return 'Please enter your email.';
  } else if (!isValidEmail(email)) {
    return 'Invalid email format';
  }
  return null;
}

String? validatePassword(String? value) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');

  if (value == null || value.isEmpty) {
    return 'Please enter your password.';
  } else if (!regex.hasMatch(value)) {
    return "Password should contain 8 characters, capital, small letter, number & special characters.";
  } else {
    return null;
  }
}

String? validateField(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Field is required';
  }
  return null;
}

String? validateFieldName(String? value, String? fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '${fieldName ?? 'Field'} is required';
  }
  return null;
}
