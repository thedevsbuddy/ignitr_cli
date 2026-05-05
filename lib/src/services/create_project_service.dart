import 'package:args/args.dart';

import '../generators/project_generator.dart';
import '../models/command_info.dart';
import 'base_service.dart';

class CreateProjectService extends BaseService {
  String? projectName;
  String? projectVersion;
  String? organizationName;
  String? selectedFlavorName;
  String? selectedStackName;

  @override
  Future<void> init(List<String> args, ArgResults argResults) async {
    await super.init(args, argResults);
    projectName = args.isNotEmpty ? args.first : null;
    organizationName = argResults['org'];
    projectName ??= askName("Project");
    organizationName ??= askOrganization();

    commandInfo = CommandInfo(rawProjectName: projectName!, organization: organizationName!);
  }

  Future<void> handle() async {
    ProjectGenerator projectGenerator = ProjectGenerator(commandInfo);
    await projectGenerator.generate();
  }
}
