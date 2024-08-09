import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppLocalizations {
  static AppLocalizations shared = AppLocalizations._();
  Map<dynamic, dynamic> _localisedValues = {};

  AppLocalizations._();

  static AppLocalizations of(BuildContext context) {
    return shared;
  }

  String text(String key) {
    return _localisedValues[key] ?? "$key not found";
  }

  // defined text
  String get commonMessageNoData => text('common_message_no_data');
  String get commonTabAll => text('common_tab_all');
  String get commonTabDoing => text('common_tab_doing');
  String get commonTabDone => text('common_tab_done');
  String get commonButtonSave => text('common_button_save');
  String get commonMessageMarkTodoAsDoing =>
      text('common_message_mark_todo_as_doing');
  String get commonMessageMarkTodoAsDone =>
      text('common_message_mark_todo_as_done');
  String get addTotoTitle => text('add_new_toto_title');
  String get addTotoTitleLabel => text('add_new_toto_label_title');
  String get addTotoHintTitleLabel => text('add_new_toto_hint_label_title');
  String get addTotoDescriptionLabel => text('add_new_toto_label_desciption');
  String get addTotoHintDescriptionLabel =>
      text('add_new_toto_hint_label_desciption');
  String get addNewTodoTitleError => text('add_new_toto_title_empty_error');
  String get addNewTodoDescriptionError =>
      text('add_new_toto_title_description_error');
  String get commonMessageConnectionError =>
      text('common_message_internet_problem');
  String get commonMessageServerMaintenance =>
      text('common_message_server_maintaince');

  Future<void> reloadLanguageBundle({required String languageCode}) async {
    String path = "assets/jsons/localization_$languageCode.json";
    String jsonContent = "";
    try {
      jsonContent = await rootBundle.loadString(path);
    } catch (_) {
      jsonContent =
          await rootBundle.loadString("assets/jsons/localization_en.json");
    }
    _localisedValues = json.decode(jsonContent);
  }
}
