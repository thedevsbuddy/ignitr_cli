import 'package:dcli/dcli.dart';

import '../models/stub.dart';
import '../utilities/utils.dart';
import 'base_generator.dart';
import 'client_generator.dart';
import 'controller_generator.dart';
import 'model_generator.dart';
import 'page_generator.dart';

class ModuleGenerator extends BaseGenerator {
  ModuleGenerator(super.commandInfo);

  Future<void> generate() async {
    // Controller
    ControllerGenerator controllerGenerator = ControllerGenerator(commandInfo);
    await controllerGenerator.init();
    await controllerGenerator.generate();

    // Service
    ClientGenerator clientGenerator = ClientGenerator(commandInfo);
    await clientGenerator.init();
    await clientGenerator.generate();

    // Page
    PageGenerator pageGenerator = PageGenerator(commandInfo);
    await pageGenerator.init();
    await pageGenerator.generate();

    // Routes
    await generateRoute();

    // Module
    await generateModuleClass();

    // Page
    ModelGenerator modelGenerator = ModelGenerator(commandInfo);
    await modelGenerator.init();
    await modelGenerator.generate();

    // Update Routes Export
    await updateRoutesExport();

    // Update Modules Export
    await updateModuleExport();
  }

  Future<void> generateModuleClass() async {
    /// Check and create directory
    Utils.makeDir(commandInfo.modulePath);

    String moduleFile = stubs.firstWhere((item) => item.type == StubType.module).content.replaceAll('{SNAKE_MODULE}', commandInfo.moduleSnake);
    moduleFile = moduleFile.replaceAll('{MODULE}', commandInfo.modulePascal);

    /// Write File
    Utils.writeFile("${commandInfo.modulePath}/${commandInfo.moduleSnake}.dart", moduleFile);

    /// Show Success message
    print(green('"${commandInfo.modulePath}/${commandInfo.moduleSnake}.dart" generated successfully!'));
  }

  Future<void> generateRoute() async {
    /// Check and create directory
    Utils.makeDir(commandInfo.routePath);

    /// Replace slots with actual value
    String routeFile = parseStub(stubs.firstWhere((item) => item.type == StubType.router).content);

    /// Write File
    Utils.writeFile("${commandInfo.routePath}/${commandInfo.moduleSnake}_router.dart", routeFile);

    /// Show Success message
    print(green('"${commandInfo.routePath}/${commandInfo.moduleSnake}_router.dart" generated successfully!'));
  }

  Future<void> updateRoutesExport() async {
    String exportLine = [
      "...${commandInfo.modulePascal}Router.routes,",
      "//%...routes%//",
    ].join('\n\t');

    String baseRouteFilePath = "${commandInfo.baseRoutePath}/router.dart";
    String routeFileContent = await Utils.readFile(baseRouteFilePath);

    if (routeFileContent.contains("...${commandInfo.modulePascal}Router.routes,")) {
      print(yellow('Route export arleady exists in $baseRouteFilePath'));
      return;
    }

    if (!routeFileContent.contains("//%...routes%//")) {
      print(yellow('Route export can not be added to `$baseRouteFilePath`'));
      print(red('Please add: `//%...routes%//` in `$baseRouteFilePath`` before `];`'));
      return;
    }

    routeFileContent = routeFileContent.replaceAll("//%...routes%//", exportLine);

    /// Write File
    Utils.writeFile(baseRouteFilePath, routeFileContent);

    /// Show Success message
    print(green('Route export added to `$baseRouteFilePath`'));
  }

  Future<void> updateModuleExport() async {
    String exportFile = "${commandInfo.moduleSnake}/${commandInfo.moduleSnake}.dart";
    String modulesFilePath = "${commandInfo.modulesPath}/modules.dart";
    String modulesFileContent = await Utils.readFile(modulesFilePath);

    if (modulesFileContent.contains(exportFile)) {
      /// Show Success message
      print(yellow('export "$exportFile" already exists in $modulesFilePath'));
      return;
    }
    modulesFileContent = "$modulesFileContent\nexport \"$exportFile\";\n";

    /// Write File
    Utils.writeFile(modulesFilePath, modulesFileContent);

    /// Show Success message
    print(green('Added `export "$exportFile"` to `$modulesFilePath`'));
  }
}
