import 'package:comics_center/domain/Series/series.dart';
import 'package:comics_center/domain/Series/series_details.dart';
import 'package:comics_center/domain/character/character.dart';
import 'package:comics_center/domain/character/character_detail.dart';
import 'package:comics_center/domain/comic/comic.dart';
import 'package:comics_center/domain/comic/comic_details.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_interceptor.dart';
import 'package:dio/dio.dart';

class MarvelRestClient {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://gateway.marvel.com:443/v1/public/'),
  )..interceptors.add(MarvelRestInterceptor());

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
        data: comicList,
      );
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

  Future<ApiResponse<SeriesDetails>> getSeriesDetails(String id) async {
    try {
      var response = await _dio.get("series/$id");
      var map = response.data["data"]["results"][0];
      print(map);
      var details = SeriesDetails.fromMap(map);
      return ApiResponse.success(data: details);
    } catch (e) {
      return ApiResponse.error();
    }
  }

  Future<ApiResponse<PaginatedData<Series>>> getSeries(
      Map<String, dynamic> query) async {
    try {
      var result = await _dio.get('series', queryParameters: query);

      var storyList = (result.data["data"]["results"] as List).map((e) {
        return Series.fromMap(e);
      }).toList();

      var paginatedData = PaginatedData<Series>(
        offset: result.data["data"]["offset"],
        total: result.data["data"]["total"],
        data: storyList,
      );

      return ApiResponse.success(data: paginatedData);
    } catch (e) {
      return ApiResponse.error();
    }
  }
}
