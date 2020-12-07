import 'dart:ui';

class ResString {
  var data = {
    'enterphoneheading': 'ENTER YOUR MOBILE NUMBER',
    'enterphonedesc':
        'We will send you an SMS with the verification code to this number',
    'privacy_policy': 'Privacy Policy',
    'term_of_uses': 'Term of use',
    'enter_code':'ENTER VERIFICAITON CODE',
    'verify_otp':'Please enter the verification code that was sent to'
  };

  String get(String key) {
    return data[key];
  }
}
