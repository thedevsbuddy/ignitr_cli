import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

import '../models/command_info.dart';

class BaseService {
  Future<void> init(List<String> args, ArgResults argResults) async {}
  late CommandInfo commandInfo;

  String? askName(String type) {
    while (true) {
      stdout.write(blue('Enter $type Name: '));
      final name = stdin.readLineSync()?.trim();
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }
  }

  String? askOrganization() {
    return ask(blue('Enter organization name:'), required: true, defaultValue: 'com.example');
  }
}
