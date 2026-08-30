import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<String?> uploadImageToCloudinary(File imageFile) async {
  String cloudName = 'dtpohlifc';

  final url = Uri.parse(
    'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
  );

  final request = http.MultipartRequest('POST', url);

  request.fields['upload_preset'] = "se7ety";

  request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      log('responseData: $responseData');
      return responseData['secure_url'];
    } else {
      log('Failed to upload image. Status code: ${response.statusCode}');
      final errorBody = await response.stream.bytesToString();
      log('Error response: $errorBody');
      return null;
    }
  } catch (e) {
    log('Error uploading image: $e');
    return null;
  }
}
