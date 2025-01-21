#! /usr/bin/env dcli

import 'package:ignitr_cli/src/command.dart';

void main(List<String> args) async {
  Command command = Command(args);
  await command.run();
}
