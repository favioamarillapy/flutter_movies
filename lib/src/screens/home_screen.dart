import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_movies/src/providers/movies_provider.dart';
import 'package:flutter_movies/src/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Movies"),
          elevation: 0,
          actions: [
            IconButton(icon: Icon(Icons.search_outlined), onPressed: () {})
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardSwiper(movies: moviesProvider.nowPlayMovies),
              MovieSlider(
                  movies: moviesProvider.popularMovies,
                  title: "Popular",
                  onNextPage: () => moviesProvider.getPopular()),
            ],
          ),
        ));
  }
}
