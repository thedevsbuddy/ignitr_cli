import "package:args/args.dart";

import "../generators/design/spacing_generator.dart";
import "../generators/design/typography_generator.dart";
import "../models/command_info.dart";
import "base_service.dart";

class DesignSystemService extends BaseService {
  @override
  Future<void> init(List<String> args, ArgResults argResults) async {
    await super.init(args, argResults);

    commandInfo = CommandInfo();
  }

  Future<void> handle() async {
    TypographyGenerator typographyGenerator = TypographyGenerator(commandInfo);
    await typographyGenerator.generate();

    SpacingGenerator spacingGenerator = SpacingGenerator(commandInfo);
    await spacingGenerator.generate();
  }
}
