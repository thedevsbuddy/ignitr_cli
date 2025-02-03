class Flavor {
  final String name;
  final String fileName;
  final String downloadUrl;
  final String contentType;

  Flavor({required this.name, required this.fileName, required this.downloadUrl, required this.contentType});

  factory Flavor.fromJson(Map<String, dynamic> json) {
    return Flavor(
      name: json['name'].split('.').first,
      fileName: json['name'],
      downloadUrl: json['browser_download_url'],
      contentType: json['content_type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'file_name': fileName,
        'browser_download_url': downloadUrl,
        'content_type': contentType,
      };
}
