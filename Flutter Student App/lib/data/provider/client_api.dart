import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencentric_lms/core/common_model/errors_model.dart';
import 'package:opencentric_lms/core/helper/help_me.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/custom_snackbar.dart';

class ApiClient extends GetxService {
  final String? appBaseUrl;
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  final int timeoutInSeconds = 30;

  String? token;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.token);
    printLog("-------apiClient constructor: token: $token");

    ///pick zone id to update header
    updateHeader(
      token,
      sharedPreferences.getString(AppConstants.languageCode),
    );
  }

  void updateHeader(String? token, String? languageCode) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Cache-Control': 'no-cache',
      AppConstants.localizationKey:
          languageCode ?? AppConstants.languages[0].languageCode!,
    };

    if (token != null) {
      _mainHeaders['Authorization'] = token;
    }
    final cookie = sharedPreferences.getString(AppConstants.cookie);
    if (cookie != null) {
      _mainHeaders['Cookie'] = cookie;
    }
    final csrfToken = sharedPreferences.getString(AppConstants.csrfToken);
    if (csrfToken != null) {
      _mainHeaders['X-CSRF-Token'] = csrfToken;
    }
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query,
      Map<String, String>? headers,
      Map<String, dynamic>? body}) async {
    try {
      final uriWithQuery =
          Uri.parse(appBaseUrl! + uri).replace(queryParameters: query);

      final request = http.Request('GET', uriWithQuery)
        ..headers.addAll(headers ?? _mainHeaders)
        ..body = jsonEncode(body);

      final streamedResponse =
          await request.send().timeout(Duration(seconds: timeoutInSeconds));
      http.Response response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        await refreshAccessToken();
        // Retry the request with the new access token
        response = await http
            .get(
              uriWithQuery,
              headers: headers ?? _mainHeaders,
            )
            .timeout(Duration(seconds: timeoutInSeconds));
      }
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    http.Response response = await http
        .post(
          Uri.parse(appBaseUrl! + uri),
          body: jsonEncode(body),
          headers: headers ?? _mainHeaders,
        )
        .timeout(Duration(seconds: timeoutInSeconds));
    try {
      if (response.statusCode == 401) {
        await refreshAccessToken();

        // Retry the request with the new access token
        response = await http
            .post(
              Uri.parse(appBaseUrl! + uri),
              body: jsonEncode(body),
              headers: headers,
            )
            .timeout(Duration(seconds: timeoutInSeconds));
      }
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> patchData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      http.Response response = await http
          .patch(
            Uri.parse(appBaseUrl! + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      if (response.statusCode == 401) {
        await refreshAccessToken();

        // Retry the request with the new access token
        response = await http
            .patch(
              Uri.parse(appBaseUrl! + uri),
              body: jsonEncode(body),
              headers: headers ?? _mainHeaders,
            )
            .timeout(Duration(seconds: timeoutInSeconds));
      }
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartDataConversation(
    String? uri,
    File file,
    String receiverId,
  ) async {
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(appBaseUrl! + uri!));
    request.headers.addAll(_mainHeaders);

    request.fields['receiver_id'] = receiverId;
    var stream = http.ByteStream(file.openRead())..cast();
    var length = await file.length();
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    final data = await request.send();

    http.Response response = await http.Response.fromStream(data);
    return handleResponse(response, uri);
  }

  Future<Response> postMultipartData(String? uri, Map<String, String> body,
      List<MultipartBody>? multipartBody, File? otherFile,
      {Map<String, String>? headers}) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(appBaseUrl! + uri!));
      request.headers.addAll(headers ?? _mainHeaders);

      if (otherFile != null) {
        Uint8List list = await otherFile.readAsBytes();
        var part = http.MultipartFile(
            'submitted_file', otherFile.readAsBytes().asStream(), list.length,
            filename: basename(otherFile.path));
        request.files.add(part);
      }

      if (multipartBody != null) {
        for (MultipartBody multipart in multipartBody) {
          File file = File(multipart.file.path);
          request.files.add(http.MultipartFile(
            multipart.key!,
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: file.path.split('/').last,
          ));
        }
      }

      request.fields.addAll(body);
      http.Response response =
          await http.Response.fromStream(await request.send());
      if (response.statusCode == 401) {
        await refreshAccessToken();

        // Retry the request with the new access token
        response = await http.Response.fromStream(await request.send());
      }
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String? uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      http.Response response = await http
          .put(
            Uri.parse(appBaseUrl! + uri!),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      if (response.statusCode == 401) {
        customSnackBar("putData error 401");
        await refreshAccessToken();

        // Retry the request with the new access token
        response = await http
            .put(
              Uri.parse(appBaseUrl! + uri),
              body: jsonEncode(body),
              headers: headers ?? _mainHeaders,
            )
            .timeout(Duration(seconds: timeoutInSeconds));
      }
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String? uri,
      {Map<String, String>? headers}) async {
    try {
      http.Response response = await http
          .delete(
            Uri.parse(appBaseUrl! + uri!),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      if (response.statusCode == 401) {
        await refreshAccessToken();

        // Retry the request with the new access token
        response = await http
            .delete(
              Uri.parse(appBaseUrl! + uri),
              headers: headers ?? _mainHeaders,
            )
            .timeout(Duration(seconds: timeoutInSeconds));
      }
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(http.Response response, String? uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      //
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      if (response0.body.toString().startsWith('{response_code:')) {
        ErrorsModel errorResponse = ErrorsModel.fromJson(response0.body);
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: errorResponse.responseCode);
      } else if (response0.body.toString().startsWith('{message')) {
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: response0.body['message']);
      }
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: noInternetMessage);
    }
    if (foundation.kDebugMode) {
      // debugPrint('====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    }
    return response0;
  }

  Future<void> refreshAccessToken() async {
    //   final res = await getData(AppConstants.sessionToken);
    //   if (res.statusCode == 200) {
    //     final csrfToken = res.body;
    //     await sharedPreferences.setString(
    //         AppConstants.csrfToken, csrfToken ?? "");
    //   }
    //   final currentToken = sharedPreferences.getString(AppConstants.token);
    //   if (currentToken != null) {
    //     final res = await getData(AppConstants.refreshToken);

    //     if (res.statusCode == 200) {
    //       token = res.body['token'];
    //       await sharedPreferences.setString(AppConstants.token, token ?? "");
    //       updateHeader(token, AppConstants.languageCode);
    //     }
    //   }
  }
}

class MultipartBody {
  String? key;
  XFile file;

  MultipartBody(this.key, this.file);
}
