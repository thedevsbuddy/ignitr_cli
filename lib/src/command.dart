import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'models/module.dart';
import 'services/create_project_service.dart';
import 'services/make_model_service.dart';
import 'services/make_module_service.dart';
import 'services/make_page_service.dart';
import 'utilities/utils.dart';

const List<Map<String, String>> _allowedCommands = [
  {"name": "create", "description": "Creates a new project", 'usage': "create <project_name> --org=<organization_name>"},
  {"name": "make:module", "description": "Generate a new module", 'usage': "make:module <module_name>"},
  {"name": "make:page", "description": "Generate a new page", 'usage': "make:page <page_name> --on=<module_name>"},
  {"name": "make:model", "description": "Generate a new model", 'usage': "make:model <model_name>"},
];

class Command {
  final List<String> args;

  String command = "";
  late ArgResults argResults;
  List<Module> existingModules = [];

  Command(this.args) {
    if (args.isEmpty) {
      _printAllowedCommands("No command provided. Use one of the following:");
      return;
    }

    final parser = ArgParser()
      ..addOption('on', help: 'Specify the module name for the page.')
      ..addOption('org', help: 'Specify the organization name.');

    // Load existing modules
    Directory moduleInfoDirectory = Directory(".ignitr/modules");
    if (moduleInfoDirectory.existsSync()) {
      for (var entity in moduleInfoDirectory.listSync(recursive: true)) {
        if (entity is File) {
          final moduleContent = entity.readAsStringSync();
          Module moduleModel = Module.fromJson(jsonDecode(moduleContent));
          existingModules.add(moduleModel);
        }
      }
    }

    try {
      argResults = parser.parse(args);
      command = args.first;
    } on FormatException catch (e) {
      print(red(e.message));
      _printAllowedCommands("Invalid arguments.");
      command = "";
    }
  }

  Future<void> run() async {
    if (command.isEmpty) return;

    // Do module validations
    Map<String, dynamic> commandValidation = _commandValidator();
    if (commandValidation["success"] != true) {
      print(red(commandValidation["message"]));
      return;
    }

    switch (command) {
      case 'create':
        final createProjectService = CreateProjectService();
        await createProjectService.init(args.skip(1).toList(), argResults);
        await createProjectService.handle();
        break;

      case 'make:module':
        final makeModuleService = MakeModuleService();
        await makeModuleService.init(args.skip(1).toList(), argResults);
        await makeModuleService.handle();
        await Utils.formatGeneratedCode();
        break;

      case 'make:page':
        final makePageService = MakePageService();
        await makePageService.init(args.skip(1).toList(), argResults);
        await makePageService.handle();
        await Utils.formatGeneratedCode();
        break;

      case 'make:model':
        final makeModelService = MakeModelService();
        await makeModelService.init(args.skip(1).toList(), argResults);
        await makeModelService.handle();
        await Utils.formatGeneratedCode();
        break;

      default:
        _printAllowedCommands('Unknown command: $command');
    }
  }

  void _printAllowedCommands(String message) {
    print(red(message));
    for (final element in _allowedCommands) {
      print(yellow("  - ${element["name"]} => ${element["description"]}"));
      print(blue("    Usage => ${element["usage"]}"));
    }
  }

  Map<String, dynamic> _commandValidator() {
    String? moduleOption = argResults['on'];

    if (command == 'make:page') {
      // Check if module name provided
      if (moduleOption == null) {
        return {
          "success": false,
          "message": "Module name not provided",
        };
      }

      // Check for module existence
      Module? module = existingModules.where((m) => m.slug == moduleOption).firstOrNull;
      String availableModules = existingModules.map((m) => m.slug).toList().join(', ');
      if (module == null) {
        return {
          "success": false,
          "message": "Invalid module name\nAvailable modules: $availableModules",
        };
      }
    }

    return {
      "success": true,
      "message": "",
    };
  }
}
