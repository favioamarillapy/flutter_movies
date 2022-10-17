import 'package:flutter/material.dart';
import 'package:flutter_movies/src/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {}
            )
        ],
      ),
      body: Column(
        children: [
          CardSwiper()
        ],
        )
    );
  }
}
