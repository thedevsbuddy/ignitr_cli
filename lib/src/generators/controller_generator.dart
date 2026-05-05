import 'package:dcli/dcli.dart';

import '../models/stub.dart';
import 'base_generator.dart';
import '../utilities/utils.dart';

class ControllerGenerator extends BaseGenerator {
  ControllerGenerator(super.commandInfo);

  Future<void> generate([bool single = false]) async {
    /// Get stub
    String stub = single ? stubs.firstWhere((item) => item.type == StubType.singleController).content : stubs.firstWhere((item) => item.type == StubType.controller).content;

    /// Generate Controller
    Utils.makeDir(commandInfo.controllerPath);

    /// Replace slots with actual value
    String controllerFileContent = parseStub(stub);

    /// Write File
    Utils.writeFile(
      "${commandInfo.controllerPath}/${commandInfo.controllerSnake}.dart",
      controllerFileContent,
    );

    /// Show Success message
    print(green('"${commandInfo.controllerPath}/${commandInfo.controllerSnake}.dart" generated successfully.'));

    /// Update module export to add the new controller
    if (single) {
      await updateModuleExport();
    }
  }

  Future<void> updateModuleExport() async {
    String exportFile = "controllers/${commandInfo.controllerSnake}.dart";
    String moduleFilePath = "${commandInfo.modulePath}/${commandInfo.moduleSnake}.dart";
    String moduleFileContent = await Utils.readFile(moduleFilePath);

    if (moduleFileContent.contains(exportFile)) {
      print(yellow('`part "controllers/${commandInfo.controllerSnake}.dart"` already exists in $moduleFilePath'));
      return;
    }
    moduleFileContent = "$moduleFileContent\npart \"$exportFile\";\n";

    /// Write File
    Utils.writeFile(moduleFilePath, moduleFileContent);

    /// Show Success message
    print(green('Added `export "${commandInfo.moduleSnake}_controller.dart"` to `$moduleFilePath`'));
  }
}
