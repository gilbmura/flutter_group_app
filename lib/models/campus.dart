import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// ALU runs two campuses (Kigali & Mauritius). Most campus apps ignore this;
/// here it is a first-class concept, so cross-campus discovery works by design.
enum Campus { kigali, mauritius, all }

extension CampusX on Campus {
  String get label {
    switch (this) {
      case Campus.kigali:
        return 'Kigali';
      case Campus.mauritius:
        return 'Mauritius';
      case Campus.all:
        return 'All campuses';
    }
  }

  Color get color {
    switch (this) {
      case Campus.kigali:
        return AppColors.kigali;
      case Campus.mauritius:
        return AppColors.mauritius;
      case Campus.all:
        return AppColors.textMuted;
    }
  }
}
