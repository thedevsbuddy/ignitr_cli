class TemplateVersion {
  final String version;
  final String versionName;
  final bool isPrerelease;

  TemplateVersion({required this.version, required this.versionName, required this.isPrerelease});

  factory TemplateVersion.fromJson(Map<String, dynamic> json) {
    return TemplateVersion(
      version: json['tag_name'],
      versionName: json['name'],
      isPrerelease: json['prerelease'],
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'versionName': versionName,
        'isPrerelease': isPrerelease,
      };
}
