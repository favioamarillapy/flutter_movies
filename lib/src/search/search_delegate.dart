import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_movies/src/models/models.dart';
import 'package:flutter_movies/src/providers/movies_provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => {query = ""},
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => {close(context, null)},
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("buildResults");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _EmptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getSearchMovies(query),
      builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return _EmptyContainer();
        }

        final List<Movie>? movies = snapshot.data;

        return ListView.builder(
          itemCount: movies!.length,
          itemBuilder: (context, index) => _MovieItem(movies[index]),
        );
      },
    );
  }
}

class _EmptyContainer extends StatelessWidget {
  const _EmptyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Icon(
      Icons.movie_creation_outlined,
      color: Colors.black38,
      size: 200,
    ));
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  const _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    movie.heroId = "search-${movie.id}";

    return Hero(
      tag: movie.heroId!,
      child: ListTile(
        leading: FadeInImage(
          placeholder: AssetImage("assets/no-image.jpg"),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () {
          Navigator.pushNamed(context, "details", arguments: movie);
        },
      ),
    );
  }
}
