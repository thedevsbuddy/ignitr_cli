import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

import 'generators/controller_generator.dart';
import 'generators/module_generator.dart';
import 'generators/page_generator.dart';
import 'generators/project_generator.dart';
import 'utilities/generator_types.dart';
import 'utilities/utils.dart';

List<Map<String, String>> _allowedCommands = [
  {"name": "create", "description": "Creates a new project", 'usage': "create <project_name>"},
  {"name": "make:module", "description": "Generate a new module", 'usage': "make:module <module_name>"},
  {"name": "make:page", "description": "Generate a new module", 'usage': "make:page <page_name> --on=<module_name>"},
];

enum CommandType {
  create,
  makeModule,
  makePage,
}

class Command {
  List<String> args = [];

  CommandType commandType = CommandType.create;

  String command = "";
  late ArgResults argResults;

  Command(this.args) {
    if (args.isEmpty) {
      print(red("No command provided. Use one of the following:"));
      for (var element in _allowedCommands) {
        print(yellow("  - ${element["name"]} => ${element["description"]}"));
        print(blue("    Usage => ${element["usage"]}"));
      }
      return;
    }

    final parser = ArgParser()..addOption('on', abbr: 'o', help: 'Specify the module name for the page.');

    // Parsing arguments
    argResults = parser.parse(args);

    command = args.first;
  }

  Future<void> run() async {
    switch (command) {
      case 'create':
        await handleCreate(args.skip(1).toList());
        Utils.formatGeneratedCode();
        break;

      case 'make:module':
        await handleMakeModule(args.skip(1).toList());
        Utils.formatGeneratedCode();
        break;

      case 'make:page':
        await handleMakePage(args.skip(1).toList(), argResults);
        Utils.formatGeneratedCode();
        break;

      default:
        print('Unknown command: $command');
    }
  }

  Future<void> handleCreate(List<String> args) async {
    String? projectName = args.isNotEmpty ? args.first : null;
    projectName ??= askName("Project");

    if (projectName == null) {
      stdout.write('Enter project name: ');
      projectName = stdin.readLineSync()?.trim();
    }

    if (projectName == null || projectName.isEmpty) {
      print('Project name is required!');
      return;
    }
    ProjectGenerator projectGenerator = ProjectGenerator(GeneratorTypes(project: projectName));
    await projectGenerator.generate();
  }

  Future<void> handleMakeModule(List<String> args) async {
    String? moduleName = args.isNotEmpty ? args.first : null;
    moduleName ??= askName("Module");
    ModuleGenerator moduleGenerator = ModuleGenerator(GeneratorTypes(module: moduleName));
    await moduleGenerator.generate();
  }

  Future<void> handleMakePage(List<String> args, ArgResults argResults) async {
    String? pageName = args.isNotEmpty ? args.first : null;
    String? moduleName = argResults['on'];
    moduleName ??= askName("Module");
    pageName ??= askName("Page");

    PageGenerator pageGenerator = PageGenerator(GeneratorTypes(module: moduleName, page: pageName));
    await pageGenerator.generate(true);
    ControllerGenerator controllerGenerator = ControllerGenerator(GeneratorTypes(module: moduleName, controller: pageName));
    await controllerGenerator.generate(true);
  }

  String? askName(String type) {
    stdout.write(blue('Enter $type name: '));
    String? name = stdin.readLineSync()?.trim();
    if (name == null || name.isEmpty) {
      return askName(type);
    }
    return name;
  }
}
