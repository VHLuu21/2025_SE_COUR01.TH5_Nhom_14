enum AppTextSize {small, normal, large}

extension AppTextSizeExt on AppTextSize{
  double get scaleFactor {
    switch(this) {
      case AppTextSize.small:
        return 0.9;
      case AppTextSize.large:
        return 1.1;
      case AppTextSize.normal:
        return 1.0;
    }
  }
  String get asString => toString().split(".").last;
}

AppTextSize appTextSizeFromString(String s){
  switch (s) {
    case "small":
      return AppTextSize.small;
    case "large":
      return AppTextSize.large;
    default:
      return AppTextSize.normal;
  }
}

