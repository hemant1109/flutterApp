import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'main_image_row.dart';

void main() {
  runApp(const MyImageApp().type(MyImageApp.ROW));
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "List page",
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: Colors.black)),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = <WordPair>{};

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        if (index.isOdd) return const Divider();
        final i = index ~/ 2;
        //Add new data when list reach to end
        if (i >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        //end
        return _buildRow(_suggestions[i], i);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List page"),
        actions: [
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.list),
            tooltip: "Saved Suggestions",
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildRow(WordPair pair, int i) {
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase + " index:$i",
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? "Removed from saved" : "Save",
      ),
      onTap: () {
        setState(() {
          alreadySaved ? _saved.remove(pair) : _saved.add(pair);
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        final tiles = _saved.map((pair) {
          return ListTile(
              title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ));
        });
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(context: context, tiles: tiles).toList()
            : <Widget>[];
        return Scaffold(
          appBar: AppBar(
            title: const Text("Saved Suggestions"),
          ),
          body: ListView(
            children: divided,
          ),
        );
      },
    ));
  }
}
