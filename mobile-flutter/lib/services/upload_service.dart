import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UploadService {
  static const cloudName = "dk2jfvopp";
  static const uploadPreset = "user_avatar_preset"; // tạo trong Cloudinary

  static Future<String?> uploadAvatar(File file) async {
    try {
      final url = Uri.parse(
          "https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      var request = http.MultipartRequest("POST", url);

      request.fields['upload_preset'] = uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        final resData = jsonDecode(await response.stream.bytesToString());
        return resData['secure_url'];
      } else {
        print("UPLOAD FAIL: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("UPLOAD ERROR: $e");
      return null;
    }
  }
}