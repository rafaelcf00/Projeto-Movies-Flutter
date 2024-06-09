import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/database_helper.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> movies;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() {
    setState(() {
      movies = DatabaseHelper.instance.fetchMovies();
    });
  }

  void _deleteMovie(int id) async {
    await DatabaseHelper.instance.deleteMovie(id);
    _fetchMovies();
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Você tem certeza que deseja excluir este filme da sua lista?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteMovie(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Filmes',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: FutureBuilder<List<Movie>>(
        future: movies,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return Center(child: Text('Clique no botão de adicionar para inserir um filme em sua lista.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Movie movie = snapshot.data![index];
              return Card(
                color: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text('Diretor: ${movie.director}', style: TextStyle(color: Colors.white)),
                            Text('Ano: ${movie.year}', style: TextStyle(color: Colors.white)),
                            Text('Gênero: ${movie.genre}', style: TextStyle(color: Colors.white)),
                            Text('Duração: ${movie.duration} min', style: TextStyle(color: Colors.white)),
                            Text('País de Origem: ${movie.country}', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        color: Colors.red,
                        iconSize: 32.0,
                        onPressed: () {
                          _confirmDelete(context, movie.id!);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/movieForm');
          _fetchMovies();
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}