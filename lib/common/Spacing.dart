// spacing.dart
import 'package:flutter/material.dart';

/// 定义 Material  spacing 规范常量
class Spacing {
  Spacing._(); // 私有构造函数，防止被实例化

  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;
}

// 或者，更直观地，为 `SizedBox` 定义预置的便捷组件
class Gap {
  Gap._();

  static Widget get extraSmall => const SizedBox.square(dimension: Spacing.extraSmall);
  static Widget get small => const SizedBox(height: Spacing.small, width: Spacing.small);
  static Widget get verticalSmall => const SizedBox(height: Spacing.small);
  static Widget get horizontalSmall => const SizedBox(width: Spacing.small);
  static Widget get medium => const SizedBox(height: Spacing.medium, width: Spacing.medium);
  static Widget get verticalMedium => const SizedBox(height: Spacing.medium);
  static Widget get horizontalMedium => const SizedBox(width: Spacing.medium);
  static Widget get large => const SizedBox(height: Spacing.large, width: Spacing.large);
  static Widget get verticalLarge => const SizedBox(height: Spacing.large);
  static Widget get horizontalLarge => const SizedBox(width: Spacing.large);
}
