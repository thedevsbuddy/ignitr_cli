import 'package:args/args.dart';

import '../generators/controller_generator.dart';
import '../generators/page_generator.dart';
import '../utilities/generator_types.dart';
import 'base_service.dart';

class MakePageService extends BaseService {
  String? moduleName;
  String? pageName;

  @override
  Future<void> init(List<String> args, ArgResults argResults) async {
    pageName = args.isNotEmpty ? args.first : null;
    moduleName = argResults['on'];
    pageName ??= askName("Page");
    moduleName ??= askName("Module");

    await super.init(args, argResults);
  }

  Future<void> handle() async {
    PageGenerator pageGenerator = PageGenerator(GeneratorTypes(module: moduleName, page: pageName));
    await pageGenerator.init();
    await pageGenerator.generate(true);

    ControllerGenerator controllerGenerator = ControllerGenerator(GeneratorTypes(module: moduleName, controller: pageName));
    await controllerGenerator.init();
    await controllerGenerator.generate(true);
  }
}
