import 'package:comics_center/character/models/character_detail.dart';
import 'package:comics_center/comic/models/comic_details.dart';
import 'package:comics_center/network/response.dart';
import 'package:comics_center/network/rest_interceptor.dart';
import 'package:dio/dio.dart';

import '../character/models/character.dart';
import '../comic/models/comic.dart';

class RestClient {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://gateway.marvel.com:443/v1/public/'))
        ..interceptors.add(RestInterceptor());

  Future<ApiResponse<PaginatedData<Character>>> getCharacter(
      Map<String, dynamic> query) async {
    try {
      var result = await _dio.get('characters', queryParameters: query);
      var characterList = (result.data["data"]["results"] as List).map((e) {
        return Character.fromMap(e);
      }).toList();
      var paginatedData = PaginatedData<Character>(
          offset: result.data["data"]["offset"],
          total: result.data["data"]["total"],
          data: characterList);
      return ApiResponse.success(data: paginatedData);
    } catch (e) {
      return ApiResponse.error();
    }
  }

  Future<ApiResponse<PaginatedData<Comic>>> getComics(
      Map<String, dynamic> query) async {
    try {
      var result = await _dio.get("comics", queryParameters: query);
      var comicList = (result.data["data"]["results"] as List).map((e) {
        return Comic.fromMap(e);
      }).toList();
      var paginatedData = PaginatedData<Comic>(
          offset: result.data["data"]["offset"],
          total: result.data["data"]["total"],
          data: comicList);
      return ApiResponse.success(data: paginatedData);
    } catch (e) {
      return ApiResponse.error();
    }
  }

  Future<ApiResponse<CharacterDetails>> getCharacterDetails(String id) async {
    try {
      var response = await _dio.get("characters/$id");
      var map = response.data["data"]["results"][0];
      var details = CharacterDetails.fromMap(map);
      return ApiResponse.success(data: details);
    } catch (e) {
      return ApiResponse.error();
    }
  }

  Future<ApiResponse<ComicDetails>> getComicDetails(String id) async {
    try {
      var response = await _dio.get("comics/$id");
      var map = response.data["data"]["results"][0];
      var details = ComicDetails.fromMap(map);
      return ApiResponse.success(data: details);
    } catch (e) {
      return ApiResponse.error();
    }
  }
}
