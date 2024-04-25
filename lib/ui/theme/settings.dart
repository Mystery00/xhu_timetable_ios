import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/material.dart';

extension SettingsExt on BuildContext {
  SettingsGroup buildSettingsGroup({
    required String title,
    required List<SettingsItem> items,
  }) {
    return SettingsGroup(
      margin: const EdgeInsets.all(8),
      settingsGroupTitle: title,
      settingsGroupTitleStyle: TextStyle(
        color: Theme.of(this).colorScheme.onSurfaceVariant,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      items: items,
    );
  }

  SettingsItem buildSettingsItem({
    required String title,
    IconData? icons,
    ImageProvider? iconImage,
    double? iconSize,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return SettingsItem(
      icons: icons,
      iconImage: iconImage,
      iconStyle: IconStyle(
        iconSize: iconSize ?? 24.0,
      ),
      title: title,
      titleStyle: TextStyle(
        color: Theme.of(this).colorScheme.onSurface,
      ),
      subtitle: subtitle,
      subtitleStyle: subtitle == null
          ? null
          : TextStyle(
              color: Theme.of(this).colorScheme.onSurface.withAlpha(170),
            ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
