import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:quran_images/helper/app_localizations.dart';

class LocaleHelper {
  BuildContext context;

  LocaleHelper({@required this.context});

  String lang(){
    return PrefService.getString("lang");
  }

  String searchHint() {
    return AppLocalizations.of(context).translate("search_hint");
  }

  String searchWord() {
    return AppLocalizations.of(context).translate("search_word");
  }

  String searchDescription() {
    return AppLocalizations.of(context).translate("search_description");
  }

  String sorah() {
    return AppLocalizations.of(context).translate("sorah");
  }

  String part() {
    return AppLocalizations.of(context).translate("part");
  }

  String islamic() {
    return AppLocalizations.of(context).translate("islamic");
  }

  String notes() {
    return AppLocalizations.of(context).translate("notes");
  }

  String noteTitle() {
    return AppLocalizations.of(context).translate("note_title");
  }

  String noteDetails() {
    return AppLocalizations.of(context).translate("note_details");
  }

  String addNewNote() {
    return AppLocalizations.of(context).translate("add_new_note");
  }

  String bookmarks() {
    return AppLocalizations.of(context).translate("bookmarks");
  }

  String bookmarkTitle() {
    return AppLocalizations.of(context).translate("bookmark_title");
  }

  String addNewBookmark() {
    return AppLocalizations.of(context).translate("add_new_bookmark");
  }

  String save() {
    return AppLocalizations.of(context).translate("save");
  }

  String edit() {
    return AppLocalizations.of(context).translate("edit");
  }

  String delete() {
    return AppLocalizations.of(context).translate("delete");
  }

  String tafseer() {
    return AppLocalizations.of(context).translate("tafseer");
  }

  String translate() {
    return AppLocalizations.of(context).translate("translate");
  }

  String azkar() {
    return AppLocalizations.of(context).translate("azkar");
  }

  String qibla() {
    return AppLocalizations.of(context).translate("qibla");
  }

  String salat() {
    return AppLocalizations.of(context).translate("salat");
  }

  String ryad() {
    return AppLocalizations.of(context).translate("ryad");
  }

  String ayaCount() {
    return AppLocalizations.of(context).translate("aya_count");
  }

  String quranSorah() {
    return AppLocalizations.of(context).translate("quran_sorah");
  }

  String aboutUs() {
    return AppLocalizations.of(context).translate("about_us");
  }

  String stopTitle() {
    return AppLocalizations.of(context).translate("stop_title");
  }

  String appPay() {
    return AppLocalizations.of(context).translate("app_pay");
  }

  String email() {
    return AppLocalizations.of(context).translate("email");
  }

  String selectPlayer() {
    return AppLocalizations.of(context).translate("select_player");
  }

  String page() {
    return AppLocalizations.of(context).translate("page");
  }

}