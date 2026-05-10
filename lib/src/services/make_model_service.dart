import 'package:args/args.dart';

import '../generators/model_generator.dart';
import '../models/command_info.dart';
import 'base_service.dart';

class MakeModelService extends BaseService {
  String? modelName;

  @override
  Future<void> init(List<String> args, ArgResults argResults) async {
    modelName = args.isNotEmpty ? args.first : null;
    modelName ??= askName("Model");

    await super.init(args, argResults);

    commandInfo = CommandInfo(modelName: modelName);
  }

  Future<void> handle() async {
    ModelGenerator modelGenerator = ModelGenerator(commandInfo);
    await modelGenerator.init();
    await modelGenerator.generate();
  }
}
