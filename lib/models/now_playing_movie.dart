import 'dart:convert';

import 'package:motchill/models/movie_model.dart';

UpcomingModel UpcomingModelFromJson(String str) =>
    UpcomingModel.fromJson(json.decode(str));

class UpcomingModel {
  UpcomingModel({
    this.dates,
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  Dates? dates;
  int? page;
  List<Movie>? results;
  int? totalPages;
  int? totalResults;
  factory UpcomingModel.fromJson(String str) =>
      UpcomingModel.fromMap(json.decode(str));
  factory UpcomingModel.fromMap(Map<String, dynamic> json) => UpcomingModel(
        dates: Dates.fromMap(json["dates"]),
        page: json["page"],
        results:
            List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class Dates {
  Dates({
    required this.maximum,
    required this.minimum,
  });

  DateTime maximum;
  DateTime minimum;

  factory Dates.fromJson(String str) => Dates.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Dates.fromMap(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );

  Map<String, dynamic> toMap() => {
        "maximum":
            "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum":
            "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
      };
}
