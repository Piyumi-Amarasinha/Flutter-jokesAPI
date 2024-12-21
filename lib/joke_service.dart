import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class JokeService {
  final Dio _dio = Dio();
  final String _cacheKey = 'cached_jokes';

  /// Fetch jokes from API or fallback to cache if offline
  Future<List<Map<String, dynamic>>> fetchJokesRow() async {
    try {
      // Attempt to fetch jokes from API
      final response = await _dio.get(
          'https://v2.jokeapi.dev/joke/Any?amount=5&blacklistFlags=nsfw');
      if (response.statusCode == 200) {
        final List<dynamic> jokesJson = response.data['jokes'];
        // Cache the jokes for offline use
        await _cacheJokes(jokesJson);
        return jokesJson.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load jokes!');
      }
    } catch (e) {
      // On failure, fallback to cached jokes
      print('Error fetching jokes: $e. Falling back to cache.');
      return await _getCachedJokes();
    }
  }

  /// Cache jokes in SharedPreferences
  Future<void> _cacheJokes(List<dynamic> jokes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(jokes));
      print('Jokes cached successfully.');
    } catch (e) {
      print('Error caching jokes: $e');
    }
  }

  /// Retrieve cached jokes from SharedPreferences
  Future<List<Map<String, dynamic>>> _getCachedJokes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJokes = prefs.getString(_cacheKey);
      if (cachedJokes != null) {
        final List<dynamic> jokesJson = jsonDecode(cachedJokes);
        print('Cached jokes retrieved successfully.');
        return jokesJson.cast<Map<String, dynamic>>();
      } else {
        throw Exception('No cached jokes available.');
      }
    } catch (e) {
      print('Error retrieving cached jokes: $e');
      return [];
    }
  }
}
