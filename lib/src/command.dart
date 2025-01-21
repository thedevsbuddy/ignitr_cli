import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:http/http.dart' as http;

import 'generators/controller_generator.dart';
import 'generators/module_generator.dart';
import 'generators/page_generator.dart';
import 'generators/project_generator.dart';
import 'ignitr.config.dart';
import 'utilities/generator_types.dart';
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
        await _getTemplateVersions();
        await handleCreate(args.skip(1).toList(), argResults);
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

  Future<void> _getTemplateVersions() async {
    final url = Uri.parse(Config.projectTemplateVersionApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> releases = List<Map<String, dynamic>>.from(json.decode(response.body));
      templateVersions = List<TemplateVersion>.from(releases.map((release) => TemplateVersion.fromJson(release)));
      templateVersions.insert(
          0,
          TemplateVersion(
            version: "latest",
            versionName: "Latest",
            isPrerelease: false,
          ));
    } else {
      print(red("Failed to fetch releases: ${response.statusCode}"));
    }
  }

  Future<void> handleCreate(List<String> args, ArgResults argResults) async {
    String? projectName = args.isNotEmpty ? args.first : null;
    String? projectVersion = argResults['version'];
    String? organizationName = argResults['organization'];
    projectName ??= askName("Project");
    projectVersion ??= _askVersion();
    organizationName ??= _askOrganization();

    if (projectName == null || projectName.isEmpty) {
      print('Project name is required!');
      return;
    }
    ProjectGenerator projectGenerator = ProjectGenerator(GeneratorTypes(
      project: projectName,
      projectVersion: projectVersion,
      organization: organizationName,
    ));
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

  String? _askVersion() {
    print(blue('Please select the ignitr version to use: '));
    for (int i = 0; i < templateVersions.length; i++) {
      TemplateVersion templateVersion = templateVersions[i];
      print('${i + 1}. ${templateVersion.version}');
    }

    // Prompt user for input
    int selectedIndex = 0;
    final input = ask(blue('Enter the number of your choice:'), required: false, validator: Ask.integer, defaultValue: '1');
    final choice = int.tryParse(input);

    if (choice != null && choice >= 1 && choice <= templateVersions.length) {
      selectedIndex = choice - 1;
    }

    return templateVersions.elementAt(selectedIndex).version;
  }

  String? _askOrganization() {
    return ask(blue('Enter the number of your choice:'), required: false, defaultValue: 'com.example');
  }
}
