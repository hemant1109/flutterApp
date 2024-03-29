import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'item_details.dart';

// for API
//https://reqres.in/
//https://www.airport-data.com/api/doc.php
//https://api.github.com/users/mralexgray/repos

class MyNetWorkApp extends StatelessWidget {
  final String title;

  const MyNetWorkApp({Key? key, required this.title}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    imageCache?.clear();
    return MaterialApp(
      title: title,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white70, foregroundColor: Colors.black)),
      home: NetworkApiList(title: title),
    );
  }
}

class NetworkApiList extends StatefulWidget {
  final String title;

  const NetworkApiList({Key? key, required this.title}) : super(key: key);

  @override
  State<NetworkApiList> createState() => _NetworkApiListState();
}

class _NetworkApiListState extends State<NetworkApiList> {
  final _saved = <Data>{};

  /*List<ItemDetails> parseItem(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<ItemDetails>((json) => ItemDetails.fromJson(json))
        .toList();
  }*/

  Future<ItemDetails> fetchItem() async {
    final response = await http.get(Uri.parse(
        'https://www.airport-data.com/api/ac_thumb.json?m=400A0B&n=20'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return parseItem(response.body);
      return compute(ItemDetails.fromJson, jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load items');
    }
  }

  late Future<ItemDetails> futureItem;

  @override
  void initState() {
    super.initState();
    futureItem = fetchItem();
  }

  Widget _buildSuggestions(ItemDetails futureItems) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: futureItems.count,
      itemBuilder: (context, index) {
        //if (index.isOdd) return const Divider();
        //final i = index ~/ 2;
        //Add new data when list reach to end
        /*var size = futureItems.data == null ? 0 : futureItems.data?.length;
        if (i >= size!) {
          _suggestions.addAll(futureItems.data!);
        }*/
        //end
        //return _buildRow(_suggestions[i], i);
        return _buildCard(futureItems.data![index], _saved);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.list),
            tooltip: "Saved Items",
          )
        ],
      ),
      body: FutureBuilder<ItemDetails>(
        future: futureItem,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildSuggestions(snapshot.requireData);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FavoriteListStateFull(saved: _saved),
    ));
  }

  Widget _buildCard(Data data, Set<Data> saved) {
    final alreadySaved = saved.contains(data);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    Image.network(
                      data.image,
                      filterQuality: FilterQuality.high,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      semanticLabel: "Loading images",
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 8),
                    title: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  data.photographer,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                flex: 8,
                              ),
                              Expanded(
                                  child: IconButton(
                                      onPressed: () {
                                        // Setting the state
                                        setState(() {
                                          // Changing icon of specific index
                                          alreadySaved == true
                                              ? saved.remove(data)
                                              : saved.add(data);
                                        });
                                      },
                                      icon: Icon(
                                        alreadySaved == true
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: alreadySaved == true
                                            ? Colors.red
                                            : null,
                                        semanticLabel: alreadySaved == true
                                            ? "Removed from saved"
                                            : "Save",
                                      )) /**/
                                  )
                            ])),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(data.link),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}

class FavoriteListStateFull extends StatefulWidget {
  final Set<Data> saved;

  const FavoriteListStateFull({Key? key, required this.saved})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FavoriteListState();
  }
}

class _FavoriteListState extends State<FavoriteListStateFull> {
  @override
  Widget build(BuildContext context) {
    final tiles = widget.saved.map((item) {
      return _buildCard(item, widget.saved);
    });
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(context: context, tiles: tiles).toList()
        : <Widget>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Items"),
      ),
      body: divided.isNotEmpty
          ? ListView.builder(
              itemCount: divided.length,
              itemBuilder: (BuildContext context, int index) {
                return divided[index];
              },
            )
          : const Center(
              child: Text("No favorites"),
            ),
    );
  }

  Widget _buildCard(Data data, Set<Data> saved) {
    final alreadySaved = saved.contains(data);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    Image.network(
                      data.image,
                      filterQuality: FilterQuality.high,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      semanticLabel: "Loading images",
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 8),
                    title: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  data.photographer,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                flex: 8,
                              ),
                              Expanded(
                                  child: IconButton(
                                      onPressed: () {
                                        // Setting the state
                                        setState(() {
                                          // Changing icon of specific index
                                          alreadySaved == true
                                              ? saved.remove(data)
                                              : saved.add(data);
                                        });
                                      },
                                      icon: Icon(
                                        alreadySaved == true
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: alreadySaved == true
                                            ? Colors.red
                                            : null,
                                        semanticLabel: alreadySaved == true
                                            ? "Removed from saved"
                                            : "Save",
                                      )) /**/
                                  )
                            ])),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(data.link),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
