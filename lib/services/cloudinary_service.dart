import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants/cloudinary_constants.dart';

class CloudinaryService {
  static Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final uri = Uri.parse(CloudinaryConstants.uploadUrl);

      var request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = CloudinaryConstants.uploadPreset
        ..files.add(
          await http.MultipartFile.fromPath('file', imageFile.path),
        );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData =
            jsonDecode(await response.stream.bytesToString());
        return responseData['secure_url'];
      } else {
        return null;
      }
    } catch (e) {
      print("Cloudinary error: $e");
      return null;
    }
  }
}
