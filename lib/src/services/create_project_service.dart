import 'package:args/args.dart';
import 'package:ignitr_cli/src/generators/stubs_generator.dart';

import '../generators/project_generator.dart';
import '../utilities/flavor.dart';
import '../utilities/generator_types.dart';
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
    projectVersion = argResults['version'];
    organizationName = argResults['organization'];
    projectName ??= askName("Project");
    projectVersion ??= askVersion();
    selectedFlavorName = askFlavor();
    selectedStackName = askStack();
    organizationName ??= askOrganization();
    await getFlavors();
  }

  Future<void> handle() async {
    Flavor selectedFlavor = availableFlavors.firstWhere((flavor) => flavor.name == "$selectedFlavorName-$selectedStackName");

    ProjectGenerator projectGenerator = ProjectGenerator(
      GeneratorTypes(
        project: projectName,
        templateUrl: selectedFlavor.downloadUrl,
        flavor: selectedFlavorName,
        organization: organizationName,
      ),
    );
    await projectGenerator.generate();

    // Download stubs
    String stubsUrl = availableStubs.firstWhere((stub) => stub.fileName == "$selectedFlavorName-$selectedStackName-stubs.zip").downloadUrl;

    StubsGenerator stubsGenerator = StubsGenerator(
      GeneratorTypes(
        project: projectName,
        stubsUrl: stubsUrl,
        flavor: selectedFlavorName,
        organization: organizationName,
      ),
    );

    await stubsGenerator.generate();
  }
}
