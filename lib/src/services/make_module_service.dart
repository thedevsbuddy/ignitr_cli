import 'package:args/args.dart';

import '../generators/module_generator.dart';
import '../models/command_info.dart';
import 'base_service.dart';

class MakeModuleService extends BaseService {
  String? moduleName;

  @override
  Future<void> init(List<String> args, ArgResults argResults) async {
    moduleName = args.isNotEmpty ? args.first : null;
    moduleName ??= askName("Module");
    await super.init(args, argResults);
    commandInfo = CommandInfo(rawModuleName: moduleName);
  }

  Future<void> handle() async {
    ModuleGenerator moduleGenerator = ModuleGenerator(commandInfo);
    await moduleGenerator.init();
    await moduleGenerator.generate();
  }
}
