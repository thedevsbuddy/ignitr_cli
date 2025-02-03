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
    stdout.write(blue('Enter $type Name: '));
    String? name = stdin.readLineSync()?.trim();
    if (name == null || name.isEmpty) {
      return askName(type);
    }
    return name;
  }

  String? askVersion() {
    print(blue('Please select the ignitr version to use: '));
    for (int i = 0; i < templateVersions.length; i++) {
      TemplateVersion templateVersion = templateVersions[i];
      print('${i + 1}. ${templateVersion.version}');
    }

    // Prompt user for input
    int selectedIndex = 0;
    final input = ask(blue('Enter the number of your choice:'), required: false, validator: Ask.integer, defaultValue: '1');
    final choice = int.tryParse(input);

    if (choice != null && choice >= 1 && choice <= templateVersions.length) {
      selectedIndex = choice - 1;
    }

    version = templateVersions.elementAt(selectedIndex).version;
    return version;
  }

  String? askFlavor() {
    print(blue('Please select flavor: '));
    for (int i = 0; i < flavors.length; i++) {
      Info flavor = flavors[i];
      print('${i + 1}. ${flavor.name}');
    }

    // Prompt user for input
    int selectedIndex = 0;
    final input = ask(blue('Enter the number of your choice:'), required: false, validator: Ask.integer, defaultValue: '1');
    final choice = int.tryParse(input);

    if (choice != null && choice >= 1 && choice <= flavors.length) {
      selectedIndex = choice - 1;
    }

    return flavors.elementAt(selectedIndex).value;
  }

  String? askStack() {
    print(blue('Please select stack: '));
    for (int i = 0; i < stacks.length; i++) {
      Info stack = stacks[i];
      print('${i + 1}. ${stack.name}');
    }

    // Prompt user for input
    int selectedIndex = 0;
    final input = ask(blue('Enter the number of your choice:'), required: false, validator: Ask.integer, defaultValue: '1');
    final choice = int.tryParse(input);

    if (choice != null && choice >= 1 && choice <= stacks.length) {
      selectedIndex = choice - 1;
    }

    return stacks.elementAt(selectedIndex).value;
  }

  String? askOrganization() {
    return ask(blue('Enter organization name:'), required: false, defaultValue: 'com.example');
  }

  Future<void> getTemplateVersions() async {
    final url = Uri.parse(Config.templateVersionsApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> releases = List<Map<String, dynamic>>.from(json.decode(response.body));
      templateVersions = List<TemplateVersion>.from(releases.map((release) => TemplateVersion.fromJson(release)));
    } else {
      print(red("Failed to fetch releases: ${response.statusCode}"));
    }
  }

  Future<void> getFlavors() async {
    final url = Uri.parse("${Config.getFlavorsUrl}/$version");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> releases = List<Map<String, dynamic>>.from(json.decode(response.body)['assets']);
      availableFlavors = List<Flavor>.from(releases.map((release) => Flavor.fromJson(release)));
      _filterFlavors();
    } else {
      print(red("Failed to fetch releases: ${response.statusCode}"));
    }
  }

  Future<void> _filterFlavors() async {
    // Filter flavors
    Set<String> uniqueFlavorNames = {};
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
        .map((item) => Info(name: ReCase(item.name).titleCase, value: item.name.toLowerCase()))
        .toList();

    // Filter stacks
    Set<String> uniquStackNames = {};
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
        .where((flavor) => uniquStackNames.add(flavor.name))
        .map((item) => Info(name: ReCase(item.name).titleCase, value: item.name.toLowerCase()))
        .toList();

    // Filter flavors
    Set<String> uniqueStubNames = {};
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
}
