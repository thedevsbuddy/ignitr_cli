import "dart:convert";
import "dart:io";

import "package:args/args.dart";
import "package:dcli/dcli.dart";

import "../models/command_info.dart";
import "../models/module.dart";

class BaseService {
  late CommandInfo commandInfo;
  List<Module> existingModules = [];

  Future<void> init(List<String> args, ArgResults argResults) async {
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
  }

  String? askName(String type) {
    while (true) {
      stdout.write(blue("Enter $type Name: "));
      final name = stdin.readLineSync()?.trim();
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }
  }

  String? askOrganization() {
    return ask(blue("Enter organization name:"), required: true, defaultValue: "com.example");
  }
}
