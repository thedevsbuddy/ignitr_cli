const String stub = """
class {MODEL}Model {
  {MODEL}Model({
    this.id,
  });

  int? id;

  {MODEL}Model copyWith({
    int? id,
  }) =>
      {MODEL}Model(
        id: id ?? this.id,
      );

  factory {MODEL}Model.fromJson(Map<String, dynamic> json) => {MODEL}Model(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
""";
