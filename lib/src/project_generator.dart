import 'package:dcli/dcli.dart';
import 'package:recase/recase.dart';

import 'base_generator.dart';

class ProjectGenerator extends BaseGenerator {
  ReCase projectName = ReCase("");
  String projectPath = "";
  String projectTempPath = "";

  ProjectGenerator(super.args) {
    projectName = ReCase(args.project ?? "");
  }

  Future<void> generate() async {
    print(blue('Creating project: ${projectName.snakeCase}'));
  }
}
