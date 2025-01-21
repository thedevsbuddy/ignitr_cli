# Ignitr

Ignitr is a simple yet powerful flutter mini framework, designed to simplify the development of Flutter applications. It provides a set of tools and utilities to streamline the process of building Flutter apps, making it easier for developers to create high-quality, feature-rich applications. Ignitr is designed to be flexible and customizable, allowing developers to tailor it to their specific needs. It is highly inpired by the other `MVC` framewords built with other technologies like [Laravel](https://laravel.com) and [CodeIgniter](https://www.codeigniter.com).

### Getting Started

```shell
dart pub global activate ignitr_cli
```

### Usage

Above command will install the ignitr cli globally in your system, now you can use the built in Ignitr commands to get started with your project development.

#### Create new Ignitr Project

```shell
ignitr create <project_name> --version=<ignitr_version>
```

- _<project_name>_: This will be the project name you want to generate, it will scaffold a new fresh project with name name provided.
- _<--version>_: This is optional option to select the Ignitr version to create project with, defaults to the `latest` version.

**NOTE: Please note sometimes ignitr command doesn't work after activating it globally specially when using Git Bash for windows, To solve this please use command as `ignitr.bat <commands>`**

### Features

Here are some fantastic features you’ll get by default when scaffolding your project with this starter template:

- **MVC Pattern**: The project follows the `MVC` pattern, which separates logic, UI, and models for better manageability. Additionally, a new service layer has been introduced to facilitate communication with APIs.
- **Modular Structure**: The modular structure allows developers to reuse modules across different projects, offering greater flexibility and scalability.
- **Module Generator**: A simple module generator tool has been added, enabling you to generate any module with a single command.
- **Local File Database**: This project includes a local file database, allowing you to create a data file for each local service and use it to store data efficiently.

## Other features

### Module Generator

Ignitr comes with the powerfull CLI tool to help you generate the modules.

#### How to use

1. `ignitr make:module <module_name>`: To generate a new module you can use this command, please make sure to use the **`singular`** name of the module.
2. `ignitr make:page <page_name> --on=<module_name>`: This command will generate a new page and associated controller inside the specified module.

#### Generate Module

```shell
ignitr make:module blog
```

_NOTE: Please make sure to use the module names as singular name_

This will generate all the files required for a `Module`

##### Generated Files Inside your project's `lib/app/modules` directory.

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

```shell
ignitr make:page comment --on=blog
```

This will generate the new view/page (`comment_page.dart`) along with it's controller (`comment_controller.dart`) file inside the `blog` Module.

##### Generated files (including previously generated views)

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
- **Stack Selection**: You can select the stack you want to use, such as GetX, Bloc, or any other stack.
- **Tailwind**: The project will include Tailwind CSS inspired styling library for styling, providing a modern, responsive and unique look and feel to your application.

### Further Documentation

Please refer to the **[Ignitr Documentation](https://ignitr.devsbuddy.com)** for more detailed information and examples on how to use Ignitr.
