import 'package:flutter/material.dart';
import 'package:bibliogame/widget/navbar.dart';

class GameInfo extends StatefulWidget {
  @override
  _GameInfo createState() => _GameInfo();
}

class _GameInfo extends State<GameInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: Navbar.appBar(context),
      drawer: Navbar.drawer(),
      body: Column(
        children: [
          Text("data"),
        ],
      ),
        floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: EdgeInsets.only(left: 20),
                child: FloatingActionButton(
                  backgroundColor: const Color.fromRGBO(194, 195, 197, 5),
                  onPressed: () => {
                    Navigator.pop(context)
                  },
                  child: Icon(Icons.arrow_back),
                  heroTag: "return",
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 20),
                child: FloatingActionButton(
                  backgroundColor: const Color.fromRGBO(194, 195, 197, 5),
                  onPressed: () => {},
                  child: Icon(Icons.add),
                  heroTag: "add",
                ),
              ),
            ]
        )
    );
  }
}
