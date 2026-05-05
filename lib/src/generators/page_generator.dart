import 'package:dcli/dcli.dart';

import '../models/stub.dart';
import 'base_generator.dart';
import '../utilities/utils.dart';

class PageGenerator extends BaseGenerator {
  PageGenerator(super.commandInfo);

  Future<void> generate([bool single = false]) async {
    /// Get stub
    String stub = stubs.firstWhere((item) => item.type == StubType.page).content;

    /// Generate Controller
    Utils.makeDir(commandInfo.pagePath);

    /// Replace slots with actual value
    String viewFile = parseStub(stub);

    /// Write File
    Utils.writeFile(
      "${commandInfo.pagePath}/${commandInfo.pageSnake}.dart",
      viewFile,
    );

    /// Show Success message
    print(green('"${commandInfo.pagePath}/${commandInfo.pageSnake}.dart" generated successfully.'));

    /// Update module export to add the new page
    if (single) {
      await updateModuleExport();
    }
  }

  Future<void> updateModuleExport() async {
    String exportFile = "views/${commandInfo.pageSnake}.dart";
    String moduleFilePath = "${commandInfo.modulePath}/${commandInfo.moduleSnake}.dart";
    String moduleFileContent = await Utils.readFile(moduleFilePath);
    if (moduleFileContent.contains(exportFile)) {
      /// Show Success message
      print(yellow('`part "${commandInfo.pageSnake}.dart"` already exists in $moduleFilePath'));
      return;
    }

    moduleFileContent = "$moduleFileContent\npart \"$exportFile\";\n";

    /// Write File
    Utils.writeFile(moduleFilePath, moduleFileContent);

    /// Show Success message
    print(green('Added `part "${commandInfo.pageSnake}.dart"` to `$moduleFilePath`'));
  }
}
