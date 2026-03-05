class FakeAuth {
  static String? _email;
  static String? _password;
  static String? userName; // Biến lưu tên hiển thị

  static bool register(String email, String password, {String? name}) {
    _email = email;
    _password = password;
    // Nếu không nhập tên, lấy phần trước chữ @ của email làm tên
    userName = (name == null || name.isEmpty) ? email.split('@')[0] : name;
    return true;
  }

  static bool login(String email, String password) {
    if (email == _email && password == _password) {
      // Giả sử đăng nhập thành công thì lấy lại tên từ email nếu userName đang null
      userName ??= email.split('@')[0];
      return true;
    }
    return false;
  }
}