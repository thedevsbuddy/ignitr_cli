#! /usr/bin/env dcli

import 'package:flutter_ignitr/src/command.dart';

void main(List<String> args) async {
  Command command = Command(args);
  await command.run();
}
