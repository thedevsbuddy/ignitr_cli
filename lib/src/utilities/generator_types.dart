class GeneratorTypes {
  final String? project;
  final String? module;
  final String? controller;
  final String? page;
  final String? templateUrl;
  final String? stubsUrl;
  final String? organization;
  final String? flavor;

  GeneratorTypes({
    this.project,
    this.module,
    this.controller,
    this.page,
    this.templateUrl,
    this.stubsUrl,
    this.organization,
    this.flavor,
  });

  Map<String, dynamic> toJson() {
    return {
      'project': project,
      'module': module,
      'controller': controller,
      'page': page,
      'templateUrl': templateUrl,
      'stubsUrl': stubsUrl,
      'organization': organization,
      'flavor': flavor,
    };
  }
}
