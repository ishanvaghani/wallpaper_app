import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentConfig {
  // We add the api key by running 'flutter run --dart-define=movieApiKey=MYKEY
  final wallpaperApiKey =
      "563492ad6f91700001000001e2bcf599263840adb9c201de068c4603";
}

final environmentConfigProvider = Provider<EnvironmentConfig>((ref) {
  return EnvironmentConfig();
});


