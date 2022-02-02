import 'package:flutter/material.dart';
import 'package:myapp/favoriteList/FavoriteList.dart';
import 'package:myapp/networkApi/main_netowrk.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class ScreenItem {
  int _id = -1;
  String _screenName = "";

  ScreenItem({
    required String screenName,
    required int id,
  }) {
    _screenName = screenName;
    _id = id;
  }
}

class _HomePageState extends State<HomePage> {
  List<ScreenItem> list = <ScreenItem>[
    ScreenItem(screenName: "Favourite List", id: 0),
    ScreenItem(screenName: "Network API List", id: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _listItems(list[index]);
        },
      ),
    );
  }

  Widget _listItems(ScreenItem screenItem) {
    return Column(
      children: [
        ListTile(
          title: Text(screenItem._screenName),
          onTap: () {
            if (screenItem._id == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          FavoriteList(title: screenItem._screenName)));
            } else if (screenItem._id == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          MyNetWorkApp(title: screenItem._screenName)));
            } else if (screenItem._id == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          FavoriteList(title: screenItem._screenName)));
            }
          },
        ),
        const Divider(
          thickness: 2,
          height: 1,
        )
      ],
    );
  }
}
