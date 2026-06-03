class Config {
  static final String version = "v0.2.0";
  static final bool inDevMode = false;
  static final String devTemplateUrl = "https://github.com/ignitr-dev/ignitr/archive/refs/heads/main.zip";
  static final String releasedTemplateUrl = "https://github.com/ignitr-dev/ignitr/archive/refs/tags/$version.zip";

  static String get templateUrl => inDevMode ? devTemplateUrl : releasedTemplateUrl;
}
