class Layers {
  List<String>? controllers;
  List<String>? networks;
  List<String>? routes;
  List<String>? views;

  Layers({
    this.controllers,
    this.networks,
    this.routes,
    this.views,
  });

  Layers copyWith({
    List<String>? controllers,
    List<String>? networks,
    List<String>? routes,
    List<String>? views,
  }) =>
      Layers(
        controllers: controllers ?? this.controllers,
        networks: networks ?? this.networks,
        routes: routes ?? this.routes,
        views: views ?? this.views,
      );

  factory Layers.fromJson(Map<String, dynamic> json) => Layers(
        controllers: List<String>.from(json["controllers"] ?? []),
        networks: List<String>.from(json["networks"] ?? []),
        routes: List<String>.from(json["routes"] ?? []),
        views: List<String>.from(json["views"] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "controllers": controllers ?? [],
        "networks": networks ?? [],
        "routes": routes ?? [],
        "views": views ?? [],
      };
}
