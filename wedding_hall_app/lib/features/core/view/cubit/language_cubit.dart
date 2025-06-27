// lib/features/locale/cubit/locale_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/helpers/hive_constants.dart';
import '../../../../config/helpers/hive_local_storge.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedLang = await HiveLocalStorge.get(
      boxName: HiveConstants.mainBox,
      key: HiveConstants.languageCodeKey,
    );
    if (savedLang != null) {
      emit(Locale(savedLang));
    }
  }

  Future<void> changeLocale(String languageCode) async {
    await HiveLocalStorge.put(
      boxName: HiveConstants.mainBox,
      key: HiveConstants.languageCodeKey,
      value: languageCode,
    );
    emit(Locale(languageCode));
  }
}