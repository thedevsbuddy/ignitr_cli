import 'package:dcli/dcli.dart';

import '../../stubs/module/module.dart' as modulr_module;
import '../../stubs/module/routes/router.dart' as modulr_router;
import 'base_generator.dart';
import 'controller_generator.dart';
import 'model_generator.dart';
import 'page_generator.dart';
import 'service_generator.dart';
import '../utilities/utils.dart';

class ModuleGenerator extends BaseGenerator {
  ModuleGenerator(super.args);

  Future<void> generate() async {
    // Controller
    ControllerGenerator controllerGenerator = ControllerGenerator(args);
    await controllerGenerator.generate();

    // Service
    ServiceGenerator serviceGenerator = ServiceGenerator(args);
    await serviceGenerator.generate();

    // Page
    PageGenerator pageGenerator = PageGenerator(args);
    await pageGenerator.generate();

    // Routes
    await generateRoute();

    // Module
    await generateModuleClass();

    // Page
    ModelGenerator modelGenerator = ModelGenerator(args);
    await modelGenerator.generate();

    // Update Routes Export
    await updateRoutesExport();

    // Update Modules Export
    await updateModuleExport();
  }

  Future<void> generateModuleClass() async {
    /// Check and create directory
    Utils.makeDir(modulePath);

    String moduleFile = modulr_module.stub.replaceAll('{SNAKE_MODULE}', moduleName.snakeCase);
    moduleFile = moduleFile.replaceAll('{MODULE}', moduleName.pascalCase);

    /// Write File
    Utils.writeFile("$modulePath/${moduleName.snakeCase}_module.dart", moduleFile);

    /// Show Success message
    print(green('"$modulePath/${moduleName.snakeCase}_module.dart" generated successfully!'));
  }

  Future<void> generateRoute() async {
    /// Check and create directory
    Utils.makeDir(routePath);

    /// Replace slots with actual value
    String routeFile = parseStub(modulr_router.stub);

    /// Write File
    Utils.writeFile("$routePath/${moduleName.snakeCase}_router.dart", routeFile);

    /// Show Success message
    print(green('"$routePath/${moduleName.snakeCase}_router.dart" generated successfully!'));
  }

  Future<void> updateRoutesExport() async {
    String exportLine = """
    /// ${moduleName.pascalCase} Routes
    ...${moduleName.camelCase}Routes,

    //%EDIT_CODE_ABOVE_THIS_LINE_AND_DONT_REMOVE_THIS_LINE%//
  """;

    String baseRouteFilePath = "$baseRoutePath/router.dart";
    String routeFileContent = await Utils.readFile(baseRouteFilePath);

    if (routeFileContent.contains("...${moduleName.camelCase}Routes,")) {
      print(yellow('Route export arleady exists in $baseRouteFilePath'));
      return;
    }

    if (!routeFileContent.contains("//%EDIT_CODE_ABOVE_THIS_LINE_AND_DONT_REMOVE_THIS_LINE%//")) {
      print(yellow('Route export can not be added to `$baseRouteFilePath`'));
      print(red('Please add: `//%EDIT_CODE_ABOVE_THIS_LINE_AND_DONT_REMOVE_THIS_LINE%//` in `$baseRouteFilePath`` before `];`'));
      return;
    }

    routeFileContent = routeFileContent.replaceAll("//%EDIT_CODE_ABOVE_THIS_LINE_AND_DONT_REMOVE_THIS_LINE%//", exportLine);

    /// Write File
    Utils.writeFile(baseRouteFilePath, routeFileContent);

    /// Show Success message
    print(green('Route export added to `$baseRouteFilePath`'));
  }

  Future<void> updateModuleExport() async {
    String exportFile = "${moduleName.snakeCase}/${moduleName.snakeCase}_module.dart";
    String modulesFilePath = "$modulesPath/modules.dart";
    String modulesFileContent = await Utils.readFile(modulesFilePath);
    if (modulesFileContent.contains(exportFile)) {
      /// Show Success message
      print(yellow('export "${moduleName.snakeCase}_module.dart" already exists in $modulesFilePath'));
      return;
    }
    modulesFileContent = """
      $modulesFileContent
      export '$exportFile';
    """;

    /// Write File
    Utils.writeFile(modulesFilePath, modulesFileContent);

    /// Show Success message
    print(green('Added `export "${moduleName.snakeCase}/${moduleName.snakeCase}_module.dart"` to `$modulesFilePath`'));
  }
}
