import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  void setLocale(Locale locale) {
    state = locale;
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, Locale>(LanguageNotifier.new);
