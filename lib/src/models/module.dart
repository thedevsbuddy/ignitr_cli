import "layers.dart";

enum ModuleType { system, feature }

class Module {
  String name;
  String slug;
  ModuleType type;
  String path;
  Layers layers;
  String entry;

  Module({
    required this.name,
    required this.slug,
    this.type = ModuleType.feature,
    required this.path,
    required this.layers,
    required this.entry,
  });

  Module copyWith({
    String? name,
    String? slug,
    ModuleType? type,
    String? path,
    Layers? layers,
    String? entry,
  }) =>
      Module(
        name: name ?? this.name,
        slug: slug ?? this.slug,
        type: type ?? this.type,
        path: path ?? this.path,
        layers: layers ?? this.layers,
        entry: entry ?? this.entry,
      );

  factory Module.fromJson(Map<String, dynamic> json) => Module(
        name: json["name"],
        slug: json["slug"],
        type: json["type"] == "feature" ? ModuleType.feature : ModuleType.system,
        path: json["path"],
        layers: json["layers"] != null ? Layers.fromJson(json["layers"]) : Layers(),
        entry: json["entry"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "type": type == ModuleType.system ? "system" : "feature",
        "path": path,
        "layers": layers.toJson(),
        "entry": entry,
      };
}
