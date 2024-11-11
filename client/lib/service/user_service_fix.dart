import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:client/service/token_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserService {
  UserService() {
    dotenv.load(fileName: '.env');
  }

  Future<Map<String, dynamic>> readUser() async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.get(
      Uri.parse('${dotenv.get("SERVER_URL")}/user/read'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<bool> updateNickname(String nickname) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.patch(
      Uri.parse('${dotenv.get("SERVER_URL")}/user/update/nickname'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'nickname': nickname,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> updateAge(String age) async {
    int ageGroup = int.parse(age.replaceAll('대', ''));

    String? accessToken = await TokenService.getAccessToken();
    final response = await http.patch(
      Uri.parse('${dotenv.get("SERVER_URL")}/user/update/age'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'age': ageGroup,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> updateGender(bool gender) async {
    var genderStr = gender ? 'M' : 'F';
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.patch(
      Uri.parse('${dotenv.get("SERVER_URL")}/user/update/gender'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'gender': genderStr,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> uploadPhoto(File image) async {
    final dio = Dio();
    String? accessToken = await TokenService.getAccessToken();

    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      ),
    });

    final response = await dio.post(
      '${dotenv.get("SERVER_URL")}/user/upload/photo',
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    return response.statusCode == 200;
  }

  Future<Uint8List?> downloadPhoto(String photoPath) async {
    try {
      final dio = Dio();
      String? accessToken = await TokenService.getAccessToken();

      final response = await dio.post(
        '${dotenv.get("SERVER_URL")}/user/download/photo',
        data: {
          'photo_url': photoPath,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      }
      return null;
    } catch (e) {
      print('이미지 다운로드 중 오류 발생: $e');
      return null;
    }
  }

  Future<bool> deleteUser() async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.patch(
      Uri.parse('${dotenv.get("SERVER_URL")}/user/delete'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> enableUser() async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.patch(
      Uri.parse('${dotenv.get("SERVER_URL")}/user/restore'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    return response.statusCode == 200;
  }
}
