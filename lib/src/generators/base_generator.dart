import 'dart:io';

import 'package:path/path.dart';
import 'package:recase/recase.dart';

import '../ignitr.config.dart';
import '../models/stub.dart';
import '../utilities/generator_types.dart';
import '../utilities/utils.dart';

class BaseGenerator {
  Map<String, String> stubReplacements = {};
  Map<String, String> nameReplacements = {};
  List<Stub> stubs = [];

  GeneratorTypes args = GeneratorTypes();

  /// ReCase properties
  ReCase moduleName = ReCase("");
  ReCase controllerName = ReCase("");
  ReCase pageName = ReCase("");
  ReCase projectName = ReCase("");

  /// String properties
  String modulePath = "";
  String modulesPath = "";
  String modelPath = "";
  String controllerPath = "";
  String servicePath = "";
  String pagePath = "";
  String routePath = "";
  String baseRoutePath = "";
  String templateUrl = "";
  String projectTempPath = "";
  String projectPath = "";
  String organizationName = "";
  String flavor = "";

  BaseGenerator(this.args) {
    moduleName = ReCase(args.module ?? "");
    moduleName = ReCase(Utils.singularize(moduleName.originalText));

    controllerName = ReCase(args.controller ?? moduleName.originalText);
    pageName = ReCase(args.page ?? moduleName.originalText);

    modulesPath = "lib/app/modules";
    modulePath = "$modulesPath/${moduleName.pascalCase}";
    modelPath = "lib/app/models";
    baseRoutePath = "lib/routes";
    controllerPath = "$modulesPath/${moduleName.snakeCase}/controllers";
    servicePath = "$modulesPath/${moduleName.snakeCase}/services";
    pagePath = "$modulesPath/${moduleName.snakeCase}/views";
    routePath = "$modulesPath/${moduleName.snakeCase}/routes";

    projectName = ReCase(args.project ?? "");
    projectPath = projectName.snakeCase;
    projectTempPath = join(projectPath, "temp");
    flavor = args.flavor ?? "pocketbase";
    if (Config.inDevMode) {
      templateUrl = Config.devProjectTemplateUrl;
    } else {
      templateUrl = args.templateUrl ?? Config.devProjectTemplateUrl;
    }

    organizationName = args.organization?.toLowerCase() ?? "com.example";

    nameReplacements = {
      'com.devsbuddy.flutter_ignitr': "$organizationName.${projectName.snakeCase}",
      'flutter_ignitr': projectName.snakeCase,
      'Ignitr': projectName.titleCase,
    };
  }

  Future<void> init() async {
    /// Load all stubs
    await _loadStubs();
  }

  String parseStub(String stub) {
    stubReplacements = {
      '{CONTROLLER}': controllerName.pascalCase,
      '{SNAKE_CONTROLLER}': controllerName.snakeCase,
      '{MODULE}': moduleName.pascalCase,
      '{MODULE_SINGULAR}': Utils.singularize(moduleName.pascalCase),
      '{MODEL}': Utils.singularize(moduleName.pascalCase),
      '{CAMEL_MODULE}': moduleName.camelCase,
      '{SNAKE_MODULE}': moduleName.snakeCase,
      '{PLURAL_MODULE}': Utils.pluralize(moduleName.snakeCase),
      '{MODULE_URL}': moduleName.paramCase,
      '{MODULE_URL_CAMEL}': moduleName.camelCase,
      '{PAGE}': pageName.pascalCase,
    };

    String file = stub;
    for (String key in stubReplacements.keys) {
      file = file.replaceAll(key, stubReplacements[key]!);
    }
    return file;
  }

  Future<void> _loadStubs() async {
    Directory stubDirectory = Directory('.ignitr/stubs');
    if (!(await stubDirectory.exists())) {
      // throw Exception("Stubs directory not found, Please run 'ignitr publish:stubs' to");
    } else {
      await for (var entity in stubDirectory.list(recursive: true)) {
        if (entity is File) {
          String stubFile = entity.readAsStringSync();
          String stubName = entity.path.split("/").last.split(".").first.replaceAll('/', "\\").split('\\').last;
          Stub stub = Stub(
            name: stubName,
            type: StubType.values.firstWhere((element) => element.name == stubName, orElse: () => StubType.controller),
            content: stubFile,
            outPath: entity.path.split("/").last.split(".").first,
          );
          stubs.add(stub);
        }
      }
    }
  }
}
