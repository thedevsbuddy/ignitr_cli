/// Represents the configuration settings for the Ignitr CLI.
/// This class provides a centralized location to manage and access
/// various configuration parameters used throughout the application.
///
class Config {
  /// The URL of the project template repository used by the Ignitr CLI.
  static final String devProjectTemplateUrl = "https://github.com/thedevsbuddy/flutter_ignitr/archive/refs/heads/main.zip";
  static final String templatesUrl = "https://api.github.com/repos/iamspydey/flutter_ignitr_multi_flavors_test/releases/tags";
  static final String templateVersion = "v0.1.7";
  static final bool inDevMode = false;
  static final String getFlavorsUrl = Config.templatesUrl;
  static final String templateVersionsApi = "https://api.github.com/repos/iamspydey/flutter_ignitr_multi_flavors_test/releases";
}
