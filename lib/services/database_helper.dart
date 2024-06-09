import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE movies (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      director TEXT NOT NULL,
      year INTEGER NOT NULL,
      genre TEXT NOT NULL,
      duration INTEGER NOT NULL,
      country TEXT NOT NULL
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS movies');
      await _createDB(db, newVersion);
    }
  }

  Future<void> insertMovie(Movie movie) async {
    final db = await instance.database;
    await db.insert('movies', movie.toMap());
  }

  Future<List<Movie>> fetchMovies() async {
    final db = await instance.database;
    final result = await db.query('movies');

    return result.map((json) => Movie.fromMap(json)).toList();
  }

  Future<void> deleteMovie(int id) async {
    final db = await instance.database;
    await db.delete('movies', where: 'id = ?', whereArgs: [id]);
  }
}