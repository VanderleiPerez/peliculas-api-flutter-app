// Se requiere cuando se quiera hacer peticiones populares, por ejemplo
import 'dart:convert';

class Movie {
  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  bool adult;
  String? backdropPath; // Se pone opcional, porque no todos lo tienen
  List<int> genreIds;
  int id;
  String originalLanguage; // Se cambió por un STRING
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  String? releaseDate; // Se cambió por un STRING
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  String? heroId;

  // POSTER PATH
  get fullPosterImg {
    if (this.posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500${this.posterPath}';
    } else {
      return 'https://i.stack.imgur.com/GNhxO.png';
    }
  }

  // BACK DROP PATH
  get fullBackDropPath {
    if (this.backdropPath != null) {
      return 'https://image.tmdb.org/t/p/w500${this.backdropPath}';
    } else {
      return 'https://i.stack.imgur.com/GNhxO.png';
    }
  }

  // Se requiere importar librería 'dart.convert'
  factory Movie.fromJson(String str) => Movie.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());

  /* Mapeo, donde se recibe el mapa json y se toma cada una de las 
  intancias y se asigna a las de la clase
  NOTA: Todos viene como STRING
  */

  factory Movie.fromMap(Map<String, dynamic> json) => Movie(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"], // SE CAMBIÓ DEL ORIGINAL
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(), // TENER PRECAUCIÓN
        posterPath: json["poster_path"],
        releaseDate: json["release_date"], // SE QUITÓ EL PARSE PARA DATE
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );
  /*
  // MAPA PARA ENVIAR A UNA API
  Map<String, dynamic> toMap() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      }; 
  */
}

/* 
enum OriginalLanguage { EN, TR }

final originalLanguageValues =
    EnumValues({"en": OriginalLanguage.EN, "tr": OriginalLanguage.TR});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
*/
