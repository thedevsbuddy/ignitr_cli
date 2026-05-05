import 'package:path/path.dart';
import 'package:recase/recase.dart';

import '../utilities/utils.dart';

class CommandInfo {
  final String? rawModuleName;
  final String? rawProjectName;
  final String? organization;
  final String? pageName;

  late final ReCase module;
  late final ReCase project;
  late final ReCase page;
  late final ReCase controller;

  CommandInfo({
    this.rawModuleName,
    this.rawProjectName,
    this.organization,
    this.pageName,
  }) {
    module = ReCase(Utils.singularize(rawModuleName ?? ""));
    project = ReCase(rawProjectName ?? "");
    page = ReCase(pageName ?? "");
    controller = ReCase(pageName ?? "");
  }

  // ========================
  // Naming helpers
  // ========================

  String get modulePascal => module.pascalCase;
  String get moduleSnake => module.snakeCase;
  String get moduleCamel => module.camelCase;
  String get moduleParam => module.paramCase;

  String get pagePascal => page.pascalCase;
  String get pageSnake => "${page.originalText.isEmpty ? moduleSnake : page.snakeCase}_page";
  String get controllerPascal => controller.pascalCase;
  String get controllerSnake => "${controller.originalText.isEmpty ? moduleSnake : controller.snakeCase}_controller";

  String get modelClass => "${Utils.singularize(modulePascal)}Model";
  String get controllerClass => controller.originalText.isNotEmpty ? "${controllerPascal}Controller" : "${module.pascalCase}Controller";
  String get pageClass => page.originalText.isNotEmpty ? "${pagePascal}Page" : "${module.pascalCase}Page";

  // ========================
  // Project helpers
  // ========================

  String get projectSnake => project.snakeCase;
  String get projectTitle => project.titleCase;
  String get packageName => "$organization.$projectSnake";

  // ========================
  // Paths
  // ========================

  String get modulesPath => "lib/app/modules";
  String get modulePath => "$modulesPath/$moduleSnake";

  String get controllerPath => "$modulePath/controllers";
  String get clientPath => "$modulePath/networks";
  String get pagePath => "$modulePath/views";
  String get routePath => "$modulePath/routes";

  String get modelPath => "lib/app/models";
  String get baseRoutePath => "lib/routes";
  String get projectPath => projectSnake;
  String get projectTempPath => join(projectPath, "temp");
}
