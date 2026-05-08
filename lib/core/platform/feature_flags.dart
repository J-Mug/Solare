import 'package:flutter/foundation.dart';

class FeatureFlags {
  static const bool hasMoodboard = !kIsWeb;
  static const bool hasWorkspace = !kIsWeb;
  static const bool hasWidgets = !kIsWeb;

  static String get webRestrictionMessage => 'PC 앱에서 사용 가능한 기능입니다';
}
