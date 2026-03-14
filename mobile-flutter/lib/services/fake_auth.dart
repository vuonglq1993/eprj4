import 'dart:io';

class FakeAuth {

  static String? _email;
  static String? _password;

  static String? userName;
  static String? phone;
  static String? address;
  static File? avatar;

  static bool register(String email, String password, {String? name}) {

    _email = email;
    _password = password;

    userName = (name == null || name.isEmpty)
        ? email.split('@')[0]
        : name;

    phone = "";
    address = "";
    avatar = null;

    return true;
  }

  static bool login(String email, String password) {

    if (email == _email && password == _password) {
      userName ??= email.split('@')[0];
      return true;
    }

    return false;
  }

  static String? get email => _email;

  static void updateProfile({
    String? name,
    String? phoneNumber,
    String? userAddress,
    File? userAvatar,
  }) {

    if (name != null) userName = name;
    if (phoneNumber != null) phone = phoneNumber;
    if (userAddress != null) address = userAddress;
    if (userAvatar != null) avatar = userAvatar;
  }
}