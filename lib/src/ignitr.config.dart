class Config {
  static final String version = "v0.1.5";
  static final bool inDevMode = true;
  static final String devTemplateUrl = "https://github.com/ignitr-dev/getx/archive/refs/heads/main.zip";
  static final String releasedTemplateUrl = "https://api.github.com/repos/ignitr-dev/getx/releases/tags/$version.zip";

  static String get templateUrl => inDevMode ? devTemplateUrl : releasedTemplateUrl;
}
