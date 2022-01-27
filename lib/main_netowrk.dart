import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'item_details.dart';

// for API
//https://reqres.in/
//https://www.airport-data.com/api/doc.php
//https://www.airport-data.com/api/ac_thumb.json?m=400A0B&n=2
//https://api.github.com/users/mralexgray/repos

class MyNetWorkApp extends StatelessWidget {
  const MyNetWorkApp({Key? key}) : super(key: key);

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
  final _suggestions = <Data>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = <Data>{};

  /*List<ItemDetails> parseItem(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<ItemDetails>((json) => ItemDetails.fromJson(json))
        .toList();
  }*/

  Future<ItemDetails> fetchItem() async {
    final response = await http.get(Uri.parse(
        'https://www.airport-data.com/api/ac_thumb.json?m=400A0B&n=2'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return parseItem(response.body);
      return ItemDetails.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load items');
    }
  }

  late Future<ItemDetails> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = fetchItem();
  }

  Widget _buildSuggestions(ItemDetails futureItems) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        if (index.isOdd) return const Divider();
        final i = index ~/ 2;
        //Add new data when list reach to end
        var size = futureItems.data == null ? 0 : futureItems.data?.length;
        if (i >= size!) {
          _suggestions.addAll(futureItems.data!);
        }
        //end
        //return _buildRow(_suggestions[i], i);
        return _buildCard(_suggestions[i]);
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
      body: FutureBuilder<ItemDetails>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildSuggestions(snapshot.requireData);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  /*Widget _buildRow(WordPair pair, int i) {
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
  }*/

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        final tiles = _saved.map((item) {
          return ListTile(
              title: Text(
                item.photographer,
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

  Widget _buildCard(Data data) {
    return SizedBox(
      height: 210,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                data.photographer,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(data.link),
              leading: Icon(
                Icons.restaurant_menu,
                color: Colors.blue[500],
              ),
            ),
        /*    const Divider(),
            ListTile(
              title: const Text(
                '(408) 555-1212',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: Icon(
                Icons.contact_phone,
                color: Colors.blue[500],
              ),
            ),
            ListTile(
              title: const Text('costa@example.com'),
              leading: Icon(
                Icons.contact_mail,
                color: Colors.blue[500],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
