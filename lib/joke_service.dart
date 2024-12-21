import 'package:dio/dio.dart';

class JokeService{
  final Dio _dio = Dio();
  Future<List<Map<String, dynamic>>> fetchJokesRow() async {
    try{
      final response = await _dio.get('https://v2.jokeapi.dev/joke/Any?amount=5&blacklistFlags=nsfw');
      if(response.statusCode == 200){
        final List<dynamic> jokesJson =response.data['jokes'];
        return jokesJson.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load jokes!');
      }
    }catch (e){
      throw Exception('Error fetching joke: $e');
    }

  }
}