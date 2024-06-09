class Movie {
  final int? id;
  final String title;
  final String director;
  final int year;
  final String genre;
  final int duration;
  final String country;

  Movie({
    this.id,
    required this.title,
    required this.director,
    required this.year,
    required this.genre,
    required this.duration,
    required this.country,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int?,
      title: map['title'] as String,
      director: map['director'] as String,
      year: map['year'] as int,
      genre: map['genre'] as String,
      duration: map['duration'] as int,
      country: map['country'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'title': title,
      'director': director,
      'year': year,
      'genre': genre,
      'duration': duration,
      'country': country,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }
}