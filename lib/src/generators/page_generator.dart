import 'package:dcli/dcli.dart';
import 'package:recase/recase.dart';

import '../../stubs/module/views/module_page.dart' as modulr_page;
import 'base_generator.dart';
import '../utilities/generator_types.dart';
import '../utilities/utils.dart';

class PageGenerator extends BaseGenerator {
  PageGenerator(super.args);

  Future<void> generate([bool single = false]) async {
    /// Validate arguments
    if (single) {
      if (!_validateArgs(args)) return;
    }

    /// Get stub
    String stub = modulr_page.stub;

    /// Generate Controller
    Utils.makeDir(pagePath);

    /// Replace slots with actual value
    String viewFile = parseStub(stub);

    /// Write File
    Utils.writeFile(
      "$pagePath/${pageName.snakeCase}_page.dart",
      viewFile,
    );

    /// Show Success message
    print(green('"$pagePath/${pageName.snakeCase}_page.dart" generated successfully.'));

    /// Update module export to add the new page
    if (single) {
      await updateModuleExport();
    }
  }

  Future<void> updateModuleExport() async {
    String exportFile = "views/${pageName.snakeCase}_page.dart";
    String moduleFilePath = "$modulePath/${moduleName.snakeCase}_module.dart";
    String moduleFileContent = await Utils.readFile(moduleFilePath);
    if (moduleFileContent.contains(exportFile)) {
      /// Show Success message
      print(yellow('`export "${pageName.snakeCase}_page.dart"` already exists in $moduleFilePath'));
      return;
    }
    moduleFileContent = """
      $moduleFileContent
      export '$exportFile';
    """;

    /// Write File
    Utils.writeFile(moduleFilePath, moduleFileContent);

    /// Show Success message
    print(green('Added `export "${controllerName.snakeCase}_page.dart"` to `$moduleFilePath`'));
  }

  bool _validateArgs(GeneratorTypes args) {
    /// Assign module name
    moduleName = ReCase(args.module ?? "");

    // Assign view path for the module
    pagePath = "lib/app/modules/${moduleName.snakeCase}/views";
    modulePath = "lib/app/modules/${moduleName.snakeCase}";

    /// Assign variable values
    pageName = ReCase(args.page ?? "");
    String? rawpageName = pageName.originalText;
    rawpageName.toLowerCase().replaceAll('page', "");
    pageName = ReCase(rawpageName);

    return true;
  }
}
