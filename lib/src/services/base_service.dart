import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:http/http.dart' as http;
import 'package:recase/recase.dart';

import '../ignitr.config.dart';
import '../utilities/flavor.dart';
import '../utilities/info.dart';
import '../utilities/template_version.dart';

class BaseService {
  List<Flavor> availableFlavors = [];
  List<Flavor> availableStubs = [];
  List<Info> flavors = [];
  List<Info> stacks = [];
  List<TemplateVersion> templateVersions = [];
  String version = Config.templateVersion;

  Future<void> init(List<String> args, ArgResults argResults) async {
    await getTemplateVersions();
    await getFlavors();
  }

  String? askName(String type) {
    while (true) {
      stdout.write(blue('Enter $type Name: '));
      final name = stdin.readLineSync()?.trim();
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }
  }

  String? askVersion() {
    if (templateVersions.isEmpty) return version;

    print(blue('Please select the ignitr version to use: '));
    final displayedVersions = templateVersions.take(5).toList();
    for (int i = 0; i < displayedVersions.length; i++) {
      final templateVersion = displayedVersions[i];
      print('${i + 1}. ${templateVersion.version}');
    }

    final selectedIndex = _askChoiceIndex(displayedVersions.length);
    version = displayedVersions[selectedIndex].version;
    return version;
  }

  String? askFlavor() {
    return _askInfoChoice('Please select flavor: ', flavors);
  }

  String? askStack() {
    return _askInfoChoice('Please select stack: ', stacks);
  }

  String? askOrganization() {
    return ask(blue('Enter organization name:'),
        required: false, defaultValue: 'com.example');
  }

  Future<void> getTemplateVersions() async {
    final url = Uri.parse(Config.templateVersionsApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final releases =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      templateVersions =
          List<TemplateVersion>.from(releases.map(TemplateVersion.fromJson));
    } else {
      print(red("Failed to fetch releases: ${response.statusCode}"));
    }
  }

  Future<void> getFlavors() async {
    final url = Uri.parse("${Config.getFlavorsUrl}/$version");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final releases =
          List<Map<String, dynamic>>.from(json.decode(response.body)['assets']);
      availableFlavors = List<Flavor>.from(releases.map(Flavor.fromJson));
      _filterFlavors();
    } else {
      print(red("Failed to fetch releases: ${response.statusCode}"));
    }
  }

  void _filterFlavors() {
    final uniqueFlavorNames = <String>{};
    flavors = availableFlavors
        .map(
          (item) => Flavor(
            name: item.name.split('-').first,
            fileName: item.fileName,
            downloadUrl: item.downloadUrl,
            contentType: item.contentType,
          ),
        )
        .where((flavor) => uniqueFlavorNames.add(flavor.name))
        .map((item) => Info(
            name: ReCase(item.name).titleCase, value: item.name.toLowerCase()))
        .toList();

    final uniqueStackNames = <String>{};
    stacks = availableFlavors
        .where((flavor) => !flavor.fileName.contains('-stub'))
        .map(
          (item) => Flavor(
            name: item.name.split('-').last,
            fileName: item.fileName,
            downloadUrl: item.downloadUrl,
            contentType: item.contentType,
          ),
        )
        .where((flavor) => uniqueStackNames.add(flavor.name))
        .map((item) => Info(
            name: ReCase(item.name).titleCase, value: item.name.toLowerCase()))
        .toList();

    final uniqueStubNames = <String>{};
    availableStubs = availableFlavors
        .where((flavor) => flavor.fileName.contains('-stub'))
        .map(
          (item) => Flavor(
            name: item.name.split('-').first,
            fileName: item.fileName,
            downloadUrl: item.downloadUrl,
            contentType: item.contentType,
          ),
        )
        .where((flavor) => uniqueStubNames.add(flavor.name))
        .toList();
  }

  String? _askInfoChoice(String prompt, List<Info> values) {
    if (values.isEmpty) return null;

    print(blue(prompt));
    for (int i = 0; i < values.length; i++) {
      final item = values[i];
      print('${i + 1}. ${item.name}');
    }

    final selectedIndex = _askChoiceIndex(values.length);
    return values[selectedIndex].value;
  }

  int _askChoiceIndex(int max) {
    final input = ask(
      blue('Enter the number of your choice:'),
      required: false,
      validator: Ask.integer,
      defaultValue: '1',
    );
    final choice = int.tryParse(input);
    if (choice != null && choice >= 1 && choice <= max) {
      return choice - 1;
    }
    return 0;
  }
}
