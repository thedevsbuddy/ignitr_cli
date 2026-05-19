import "package:args/args.dart";
import "package:dcli/dcli.dart";

import "../generators/controller_generator.dart";
import "../generators/page_generator.dart";
import "../models/command_info.dart";
import "../models/module.dart";
import "base_service.dart";

class MakePageService extends BaseService {
  String? moduleName;
  String? pageName;

  @override
  Future<void> init(List<String> args, ArgResults argResults) async {
    pageName = args.isNotEmpty ? args.first : null;
    moduleName = argResults["on"];
    pageName ??= askName("Page");
    moduleName ??= askName("Module");

    await super.init(args, argResults);
    commandInfo = CommandInfo(rawModuleName: moduleName, pageName: pageName);
  }

  Future<void> handle() async {
    // Do module validations
    Map<String, dynamic> commandValidation = _commandValidator();
    if (commandValidation["success"] != true) {
      print(red(commandValidation["message"]));
      return;
    }

    PageGenerator pageGenerator = PageGenerator(commandInfo);
    await pageGenerator.init();
    await pageGenerator.generate(true);

    ControllerGenerator controllerGenerator = ControllerGenerator(commandInfo);
    await controllerGenerator.init();
    await controllerGenerator.generate(true);
  }

  Map<String, dynamic> _commandValidator() {
    // Check if module name provided
    if (moduleName == null) {
      return {
        "success": false,
        "message": "Module name not provided",
      };
    }

    // Check for module existence
    Module? module = existingModules.where((m) => m.slug == commandInfo.modelSnake).firstOrNull;
    String availableModules = existingModules.map((m) => m.slug).toList().join(", ");
    if (module == null) {
      return {
        "success": false,
        "message": "Invalid module name\nAvailable modules: $availableModules",
      };
    }

    return {
      "success": true,
      "message": "",
    };
  }
}
