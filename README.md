# Ignitr CLI

Ignitr CLI is a command line interface (CLI) tool that helps you get started with Ignitr projects, a powerful and flexible Flutter project generator. With Ignitr CLI, you can easily create new Flutter projects, generate modules.

### Getting Started

```shell
dart pub global activate ignitr_cli
```

### Usage

Above command will install the `ignitr_cli` globally in your system, now you can use the built in Ignitr commands to get started with your project's development.

**NOTE: Sometimes ignitr command doesn't work after activating it globally specially when using Git Bash for windows, To solve this please use command as `ignitr.bat <commands>`, Alternatively you can add alias to your `.bashrc` file. To do so please run the following command in your (Git Bash) terminal: `echo alias ignitr=\"ignitr.bat\" >> ~/.bashrc`, If you use `.bash_profile` replace `.bashrc` with `.bash_profile`**

### Available Commands

Ignitr CLI provides a set of commands to help you generate modules and files for your Flutter projects. Here are some of the most commonly used commands:

1. `ignitr create <project_name>`: This command will create a new Ignitr project with the specified name.
2. `ignitr make:module <module_name>`: To generate a new module you can use this command, please make sure to use the **`singular`** name of the module.
3. `ignitr make:page <page_name> --on=<module_name>`: This command will generate a new page and associated controller inside the specified module.

#### Generate Ignitr Project

```shell
ignitr create <project_name>
```

This will generate all the files required for a `Ignitr` project.

#### Generate Module

After generating the project, you can generate a new module by running the following command in your project's root directory:

_NOTE: Please make sure to use the module name as `singular` name_

```shell
ignitr make:module blog
```

This will generate all the files required for a `blog` module inside your project's `lib/app/modules` directory:

```txt
📂 blog
├── 📂 controllers
│   └── 📄 blog_controller.dart
├── 📂 routes
│   ├── 📄 blog_router.dart
├── 📂 services
│   ├── 📄 api_blog_service.dart
│   ├── 📄 blog_service.dart
│   └── 📄 local_blog_service.dart
├── 📂 views
│   └── 📄 blog_page.dart
└── 📄 blog_module.dart
```

#### Generate Page/View

After generating the module, you can generate a new page/view by running the following command in your project's root directory:

```shell
ignitr make:page comment --on=blog
```

This will generate the new view/page (`comment_page.dart`) along with it's controller (`comment_controller.dart`) file inside the `blog` Module.
If you dont pass the `--on` flag, it will ask you to enter the module name.

```txt
📂 blog
├── 📂 controllers
│   ├── 📄 blog_controller.dart
│   └── 📄 comment_controller.dart
├── 📂 views
│   └── 📄 blog_page.dart
│   └── 📄 comment_page.dart
```

### Upcoming features

- **Version Control**: The project will include a version control system, allowing you to rollback to the previous version of the project and more.
- **Stack Selection**: You can select the stack you want to use, such as GetX (MVCs), Bloc, Riverpod or MVVM, providing flexibility and customization options for your project.
- **Tailwind**: The project will support Tailwind CSS like styling, enabling you to create responsive and visually appealing designs for your Flutter applications.

### Further Documentation

Please refer to the **[Ignitr Documentation](https://ignitr.devsbuddy.com)** for more detailed information and examples on how to use Ignitr.
