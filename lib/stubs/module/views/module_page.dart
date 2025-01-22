const String stub = """
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/views/layouts/master_layout.dart';
import '../../../shared/views/widgets/widgets.dart';
import '../controllers/{SNAKE_CONTROLLER}_controller.dart';

class {PAGE}Page extends StatelessWidget {
  {PAGE}Page({super.key});
  
  final {CONTROLLER}Controller controller = {CONTROLLER}Controller.instance;
  
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isBusy 
          ? LoadingIconWidget(message: "Please wait...") 
          : MasterLayout(
              title: "{MODULE}",
              body: SafeArea(
                child: Center(
                  child: Text("Build awesome page here."),
                ),
              ),
            ),
          );
  }
}
""";
