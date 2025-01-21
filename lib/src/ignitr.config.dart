/// Represents the configuration settings for the Ignitr CLI.
/// This class provides a centralized location to manage and access
/// various configuration parameters used throughout the application.
///
class Config {
  /// The URL of the project template repository used by the Ignitr CLI.
  static final String projectTemplateUrl = "https://github.com/thedevsbuddy/flutter_ignitr/archive/refs";
  static final String projectTemplateVersion = "v0.1.0";
  static final bool inDevMode = true;
  static final String projectTemplateVersionApi = "https://api.github.com/repos/thedevsbuddy/flutter_ignitr/releases";
}
