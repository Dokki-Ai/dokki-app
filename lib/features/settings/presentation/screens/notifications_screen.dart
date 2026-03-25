import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushEnabled = true;
  bool _emailEnabled = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Уведомления'),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            activeColor: AppColors.accent,
            tileColor: AppColors.surface,
            title: Text('Push-уведомления', style: textTheme.bodyLarge),
            subtitle: Text(
              'Получать уведомления на устройство',
              style:
                  textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            value: _pushEnabled,
            onChanged: (bool value) => setState(() => _pushEnabled = value),
          ),
          const Divider(color: AppColors.border, height: 1),
          SwitchListTile(
            activeColor: AppColors.accent,
            tileColor: AppColors.surface,
            title: Text('Email-уведомления', style: textTheme.bodyLarge),
            subtitle: Text(
              'Получать уведомления на почту',
              style:
                  textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            value: _emailEnabled,
            onChanged: (bool value) => setState(() => _emailEnabled = value),
          ),
          const Divider(color: AppColors.border, height: 1),
        ],
      ),
    );
  }
}
