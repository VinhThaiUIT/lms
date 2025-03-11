import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:opencentric_lms/utils/enum.dart';

class CustomPhotoController extends GetxController {
  CustomPhotoController({required this.id, required this.urlPhoto, required this.title});
  final int id;
  final String urlPhoto;
  final String title;

  AppState _appState = AppState.loading;
  AppState get appState => _appState;

  factory CustomPhotoController.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': int id, 'urlPhoto': String urlPhoto, 'title': String title} => CustomPhotoController(
        id: id,
        urlPhoto: urlPhoto,
        title: title
        ),
        _ => throw const FormatException('Fail to load photo'),
    };
  }

  Future<CustomPhotoController> fetchPhoto() async{
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if(response.statusCode == 200) {
      return CustomPhotoController.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } 
    else {
      throw Exception('Fail to load photo.');
    }
  }


  }
