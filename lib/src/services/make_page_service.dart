import 'package:args/args.dart';

import '../generators/controller_generator.dart';
import '../generators/page_generator.dart';
import '../models/command_info.dart';
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

    commandInfo = CommandInfo(rawModuleName: moduleName, pageName: pageName);
  }

  Future<void> handle() async {
    PageGenerator pageGenerator = PageGenerator(commandInfo);
    await pageGenerator.init();
    await pageGenerator.generate(true);

    ControllerGenerator controllerGenerator = ControllerGenerator(commandInfo);
    await controllerGenerator.init();
    await controllerGenerator.generate(true);
  }
}
