import 'package:flutter/material.dart';

/// Centralized icon registry — never use raw `Icons.*` in the UI.
///
/// Each entry is a semantic alias so call sites read as `MyIcons.<name>`,
/// and the underlying Material icon can be swapped in a single place.
class MyIcons {
  MyIcons._();

  // --- Semantic aliases ---
  static const IconData back = Icons.arrow_back_ios_new_rounded;
  static const IconData email = Icons.mail_outline_rounded;
  static const IconData verified = Icons.check_circle_outline_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData clock = Icons.access_time_rounded;
  static const IconData fee = Icons.attach_money_rounded;
  static const IconData location = Icons.location_on_outlined;

  // --- Material icon aliases ---
  static const IconData accessTime = Icons.access_time;
  static const IconData accessTimeRounded = Icons.access_time_rounded;
  static const IconData accountCircleRounded = Icons.account_circle_rounded;
  static const IconData add = Icons.add;
  static const IconData adminPanelSettingsOutlined = Icons.admin_panel_settings_outlined;
  static const IconData attachMoney = Icons.attach_money;
  static const IconData attachMoneyRounded = Icons.attach_money_rounded;
  static const IconData calendarMonthRounded = Icons.calendar_month_rounded;
  static const IconData calendarTodayOutlined = Icons.calendar_today_outlined;
  static const IconData calendarTodayRounded = Icons.calendar_today_rounded;
  static const IconData cameraAlt = Icons.camera_alt;
  static const IconData cameraAltRounded = Icons.camera_alt_rounded;
  static const IconData cancelOutlined = Icons.cancel_outlined;
  static const IconData chatBubbleOutlineRounded = Icons.chat_bubble_outline_rounded;
  static const IconData scheduleRounded = Icons.schedule_rounded;
  static const IconData arrowForwardRounded = Icons.arrow_forward_rounded;
  static const IconData rateReviewRounded = Icons.rate_review_rounded;
  static const IconData checkCircleOutline = Icons.check_circle_outline;
  static const IconData checkCircleOutlineRounded = Icons.check_circle_outline_rounded;
  static const IconData checkCircleRounded = Icons.check_circle_rounded;
  static const IconData checkRounded = Icons.check_rounded;
  static const IconData chevronRightRounded = Icons.chevron_right_rounded;
  static const IconData circle = Icons.circle;
  static const IconData closeRounded = Icons.close_rounded;
  static const IconData editOutlined = Icons.edit_outlined;
  static const IconData emailOutlined = Icons.email_outlined;
  static const IconData favorite = Icons.favorite;
  static const IconData favoriteBorder = Icons.favorite_border;
  static const IconData favoriteBorderRounded = Icons.favorite_border_rounded;
  static const IconData favoriteRounded = Icons.favorite_rounded;
  static const IconData homeRounded = Icons.home_rounded;
  static const IconData infoOutline = Icons.info_outline;
  static const IconData keyboardArrowDown = Icons.keyboard_arrow_down;
  static const IconData locationOnOutlined = Icons.location_on_outlined;
  static const IconData locationOnRounded = Icons.location_on_rounded;
  static const IconData lockOutline = Icons.lock_outline;
  static const IconData lockOutlineRounded = Icons.lock_outline_rounded;
  static const IconData logout = Icons.logout;
  static const IconData logoutRounded = Icons.logout_rounded;
  static const IconData medicalServicesOutlined = Icons.medical_services_outlined;
  static const IconData menuBook = Icons.menu_book;
  static const IconData menuBookOutlined = Icons.menu_book_outlined;
  static const IconData menuBookRounded = Icons.menu_book_rounded;
  static const IconData menuRounded = Icons.menu_rounded;
  static const IconData notificationsNoneRounded = Icons.notifications_none_rounded;
  static const IconData people = Icons.people;
  static const IconData peopleOutline = Icons.people_outline;
  static const IconData person = Icons.person;
  static const IconData personOutline = Icons.person_outline;
  static const IconData personOutlineRounded = Icons.person_outline_rounded;
  static const IconData personRounded = Icons.person_rounded;
  static const IconData phoneRounded = Icons.phone_rounded;
  static const IconData playArrowRounded = Icons.play_arrow_rounded;
  static const IconData privacyTipOutlined = Icons.privacy_tip_outlined;
  static const IconData search = Icons.search;
  static const IconData searchOffRounded = Icons.search_off_rounded;
  static const IconData searchRounded = Icons.search_rounded;
  static const IconData settings = Icons.settings;
  static const IconData settingsOutlined = Icons.settings_outlined;
  static const IconData settingsRounded = Icons.settings_rounded;
  static const IconData shieldRounded = Icons.shield_rounded;
  static const IconData star = Icons.star;
  static const IconData starBorder = Icons.star_border;
  static const IconData starBorderRounded = Icons.star_border_rounded;
  static const IconData starHalfRounded = Icons.star_half_rounded;
  static const IconData starOutlineRounded = Icons.star_outline_rounded;
  static const IconData starRounded = Icons.star_rounded;
  static const IconData thumbUpRounded = Icons.thumb_up_rounded;
  static const IconData visibility = Icons.visibility;
  static const IconData visibilityOff = Icons.visibility_off;
  static const IconData visibilityOffOutlined = Icons.visibility_off_outlined;
  static const IconData visibilityOutlined = Icons.visibility_outlined;
  static const IconData wcRounded = Icons.wc_rounded;
}
