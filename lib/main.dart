import 'package:flutter/material.dart';
import 'joke_service.dart';
import 'joke_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final JokeService _jokeService = JokeService();
  List<Map<String, dynamic>> _jokesRaw = [];
  bool _isLoading = false;
  String _statusMessage = 'Welcome to the Joke App!';

  Future<void> _fetchJokes() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Fetching jokes...';
    });
    try {
      _jokesRaw = await _jokeService.fetchJokesRow();
      setState(() {
        _statusMessage = 'Jokes fetched successfully!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to fetch jokes. Showing cached jokes.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joke App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _statusMessage,
              style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchJokes,
              child: Text(_isLoading ? 'Loading...' : 'Fetch Jokes'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildJokeList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJokeList() {
    if (_jokesRaw.isEmpty) {
      return const Center(
        child: Text('No jokes available.'),
      );
    }
    return ListView.builder(
      itemCount: _jokesRaw.length,
      itemBuilder: (context, index) {
        final joke = _jokesRaw[index];
        return JokeCard(
          jokeText: joke['joke'] ?? 'No joke text available',
          jokeNumber: index + 1,
          category: joke['category'] ?? 'Unknown',
        );
      },
    );
  }
}
