const String stub = """
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/views/layouts/master_layout.dart';
import '../../../shared/views/widgets/widgets.dart';
import '../controllers/{SNAKE_CONTROLLER}_controller.dart';

class {PAGE}Page extends StatelessWidget {
  const {PAGE}Page({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<{CONTROLLER}Controller>(
      init: {CONTROLLER}Controller(),
      builder: ({CONTROLLER}Controller controller) {
       if (controller.isBusy) return LoadingIconWidget(message: "Please wait...");
        return MasterLayout(
          title: "{MODULE}",
          body: SafeArea(
            child: Center(
              child: Text("Build awesome page here."),
            ),
          ),
        );
      },
    );
  }
}
""";
