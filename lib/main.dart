import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/movie_list_screen.dart';
import 'screens/movie_form_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      initialRoute: '/',
      routes: {
        '/': (context) => DashboardScreen(),
        '/movieList': (context) => MovieListScreen(),
        '/movieForm': (context) => MovieFormScreen(),
      },
    );
  }
}
