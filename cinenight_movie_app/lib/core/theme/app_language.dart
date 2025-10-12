class AppLanguage {
  final String code;   // locale code cho Flutter
  final String api;    // param cho TMDB
  final String name;   // hiển thị

  AppLanguage(this.code, this.api, this.name);
}

final languages = [
  AppLanguage('en', 'en-US', 'English'),
  AppLanguage('vi', 'vi-VN', 'Tiếng Việt'),
];
