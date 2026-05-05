enum StubType {
  controller,
  singleController,
  model,
  router,
  client,
  apiClient,
  page,
  module,
}

class Stub {
  final StubType type;
  final String name;
  final String content;

  Stub({
    required this.name,
    required this.type,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.name,
      'content': content,
    };
  }
}
