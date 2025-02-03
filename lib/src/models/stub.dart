enum StubType {
  controller,
  singleController,
  model,
  router,
  service,
  localService,
  remoteService,
  page,
  module,
}

class Stub {
  final StubType type;
  final String name;
  final String content;
  final String outPath;

  Stub({
    required this.name,
    required this.type,
    required this.content,
    required this.outPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.name,
      'content': content,
      'outPath': outPath,
    };
  }
}
