// ignore_for_file: avoid_print

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:ignitr_cli/src/services/create_project_service.dart';

import 'services/make_module_service.dart';
import 'services/make_page_service.dart';
import 'utilities/template_version.dart';
import 'utilities/utils.dart';

List<Map<String, String>> _allowedCommands = [
  {"name": "create", "description": "Creates a new project", 'usage': "create <project_name> --version=<template_version> --organization=<organization_name>"},
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
  List<TemplateVersion> templateVersions = [];

  Command(this.args) {
    if (args.isEmpty) {
      print(red("No command provided. Use one of the following:"));
      for (var element in _allowedCommands) {
        print(yellow("  - ${element["name"]} => ${element["description"]}"));
        print(blue("    Usage => ${element["usage"]}"));
      }
      return;
    }

    final parser = ArgParser()
      ..addOption('on', help: 'Specify the module name for the page.')
      ..addOption('version', help: 'Specify the verion to use for your project.')
      ..addOption('organization', help: 'Specify the organization name.');

    // Parsing arguments
    argResults = parser.parse(args);

    command = args.first;
  }

  Future<void> run() async {
    // Check for the commands
    switch (command) {
      case 'create':
        // Fetch the template versions
        CreateProjectService createProjectService = CreateProjectService();
        await createProjectService.init(args.skip(1).toList(), argResults);
        await createProjectService.handle();
        break;

      case 'make:module':
        // Fetch the template versions
        MakeModuleService makeModuleService = MakeModuleService();
        await makeModuleService.init(args.skip(1).toList(), argResults);
        await makeModuleService.handle();
        Utils.formatGeneratedCode();
        break;

      case 'make:page':
        // Fetch the template versions
        MakePageService makePageService = MakePageService();
        await makePageService.init(args.skip(1).toList(), argResults);
        await makePageService.handle();
        Utils.formatGeneratedCode();
        break;

      default:
        print('Unknown command: $command');
    }
  }
}
