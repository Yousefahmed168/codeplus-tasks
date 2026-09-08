import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Service to upload images to Cloudinary.
///
/// Configure [cloudName], [uploadPreset], and optionally [apiKey] before use.
/// For unsigned uploads (recommended for mobile), only [cloudName] and
/// [uploadPreset] are required.
class CloudinaryService {
  CloudinaryService._();

  static final CloudinaryService instance = CloudinaryService._();

  // ── Configure these with your Cloudinary credentials ──────────────────
  /// Your Cloudinary cloud name (found in the dashboard).
  String cloudName = 'dtpohlifc';

  /// The unsigned upload preset configured in your Cloudinary settings.
  /// Must be set to "Unsigned" or a custom preset.
  String uploadPreset = 'se7ety';

  /// Optional: API key for signed uploads. Leave null for unsigned uploads.
  String? apiKey;
  // ──────────────────────────────────────────────────────────────────────

  String get _uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  /// Uploads an image file to Cloudinary and returns the secure URL.
  ///
  /// [filePath] is the local path of the image to upload.
  /// [folder] is an optional Cloudinary folder name (e.g. 'doctors').
  /// Returns the secure URL string on success, throws on failure.
  Future<String> uploadImage({required String filePath, String? folder}) async {
    final dio = Dio();

    final fileName = filePath.split(Platform.pathSeparator).last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'upload_preset': uploadPreset,
      'folder': ?folder,
    });

    try {
      final response = await dio.post(
        _uploadUrl,
        data: formData,
        onSendProgress: (sent, total) {
          debugPrint(
            'Upload progress: ${(sent / total * 100).toStringAsFixed(1)}%',
          );
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final secureUrl = data['secure_url'] as String;
        debugPrint('Cloudinary upload success: $secureUrl');
        return secureUrl;
      } else {
        throw Exception('Cloudinary upload failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      throw Exception(
        'Cloudinary upload error: ${e.message}. Details: $errorData',
      );
    }
  }

  /// Uploads image from bytes (useful for web platform).
  Future<String> uploadImageBytes({
    required List<int> bytes,
    required String fileName,
    String? folder,
  }) async {
    final dio = Dio();

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
      'upload_preset': uploadPreset,
      'folder': ?folder,
    });

    try {
      final response = await dio.post(_uploadUrl, data: formData);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['secure_url'] as String;
      } else {
        throw Exception('Cloudinary upload failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorData = e.response?.data;
      throw Exception(
        'Cloudinary upload error: ${e.message}. Details: $errorData',
      );
    }
  }
}
