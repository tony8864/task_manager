import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_manager/shared/widgets/nav_widget.dart';
import 'package:task_manager/view/settings/widgets/abstract_setting_widget.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: EdgeInsets.only(top: 70),
        width: double.infinity,
        child: Column(
          children: [
            _settingsTitle(Theme.of(context).colorScheme.secondary),
            _logoutSetting(context),
            const Spacer(),
            _navWidget(),
          ],
        ),
      ),
    );
  }

  Widget _settingsTitle(Color color) {
    return Text('Settings', style: GoogleFonts.merriweather(fontSize: 40, color: color));
  }

  Widget _logoutSetting(BuildContext context) {
    return AbstractSettingWidget(
      icon: Icons.logout,
      text: 'Log out',
      onTap: () {
        context.read<AuthBloc>().add(LogoutEvent());
      },
    );
  }

  Widget _navWidget() {
    return NavWidget(isHomeActive: false, onPressed: null, isFloatingButtonActive: false);
  }
}
