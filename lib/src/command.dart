import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'services/create_project_service.dart';
import 'services/make_module_service.dart';
import 'services/make_page_service.dart';
import 'utilities/utils.dart';

const List<Map<String, String>> _allowedCommands = [
  {"name": "create", "description": "Creates a new project", 'usage': "create <project_name> --org=<organization_name>"},
  {"name": "make:module", "description": "Generate a new module", 'usage': "make:module <module_name>"},
  {"name": "make:page", "description": "Generate a new page", 'usage': "make:page <page_name> --on=<module_name>"},
];

class Command {
  final List<String> args;

  String command = "";
  late ArgResults argResults;

  Command(this.args) {
    if (args.isEmpty) {
      _printAllowedCommands("No command provided. Use one of the following:");
      return;
    }

    final parser = ArgParser()
      ..addOption('on', help: 'Specify the module name for the page.')
      ..addOption('org', help: 'Specify the organization name.');

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
}
