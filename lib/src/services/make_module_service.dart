import 'package:args/args.dart';

import '../generators/module_generator.dart';
import '../utilities/generator_types.dart';
import 'base_service.dart';

class MakeModuleService extends BaseService {
  String? moduleName;

  @override
  Future<void> init(List<String> args, ArgResults argResults) async {
    moduleName = args.isNotEmpty ? args.first : null;
    moduleName ??= askName("Module");
    await super.init(args, argResults);
  }

  Future<void> handle() async {
    ModuleGenerator moduleGenerator = ModuleGenerator(GeneratorTypes(module: moduleName));
    await moduleGenerator.init();
    await moduleGenerator.generate();
  }
}
