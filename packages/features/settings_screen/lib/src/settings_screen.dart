import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

import 'package:components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_screen/src/settings_cubit.dart';
import 'package:user_repository/user_repository.dart';

class SettingsScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final UserRepository userRepository;

  const SettingsScreen(
      {Key? key, required this.scaffoldKey, required this.userRepository})
      : super(key: key);

  static const routeName = 'settings-screen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // late UserPrefsDM _userPrefs;
  final _headersStyle = const TextStyle(color: Colors.grey, fontSize: 15);

  void _onTapMenu() {
    widget.scaffoldKey.currentState!.openDrawer();
  }

  void _onAppLanguageChanged(BuildContext context, AppLanguageDM appLanguage) {
    context.read<SettingsCubit>().changeAppLanguage(appLanguage);
/*      widget.userRepository
          .upsertUserPrefs(_userPrefs.copyWith(appLanguage: appLanguage));*/
  }

  void _onFontSizeChanged(BuildContext context, int fontSize) {
    context.read<SettingsCubit>().changeFontSize(fontSize);
  }

  void _onDarkModeChanged(BuildContext context, DarkModeDM darkMode) {
    context.read<SettingsCubit>().changeDarkMode(darkMode);
  }

  void _onIsPasteFromClipboardChanged(BuildContext context, bool isPaste) {
    context.read<SettingsCubit>().changeIsPasteFromClipboard(isPaste);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(userRepository: widget.userRepository)
        ..initializeSettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Scaffold(
            appBar: AppBar(
              backgroundColor:
                  isDark ? kAppBarColorDarkMode : kAppBarColorLightMode,
              title: const Text('Settings'),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: _onTapMenu,
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Text('General', style: _headersStyle),
                    const Expanded(
                      child: DividerCommon(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Language',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize),
                    ),
                    const Spacer(),
                    DropdownButton<AppLanguageDM>(
                        value: state.appLanguage,
                        underline: Container(),
                        items: AppLanguageDM.values
                            .map(
                              (l) => DropdownMenuItem<AppLanguageDM>(
                                value: l,
                                child: Text(l.name.toCapital()),
                              ),
                            )
                            .toList(),
                        onChanged: (a) => _onAppLanguageChanged(context, a!)),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Appearance', style: _headersStyle),
                    const Expanded(
                      child: DividerCommon(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Font Size',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize),
                    ),
                    const Spacer(),
                    DropdownButton<int>(
                        value: state.fontSize,
                        underline: Container(),
                        items: [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]
                            .map(
                              (f) => DropdownMenuItem<int>(
                                value: f,
                                child: Text(f.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => _onFontSizeChanged(context, v!)),
                    const Spacer(),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize),
                    ),
                    const Spacer(),
                    AnimatedToggleSwitch<DarkModeDM>.rolling(
                      current: state.darkMode,
                      values: const [
                        DarkModeDM.alwaysLight,
                        DarkModeDM.alwaysDark,
                        DarkModeDM.systemSettings
                      ],
                      onChanged: (d) => _onDarkModeChanged(context, d),
                      height: 50,
                      // indicatorColor: Theme.of(context).primaryColor,
                      // indicatorBorderRadius: BorderRadius.circular(15),
                      borderColor: Colors.transparent,
                      innerColor:
                          isDark ? kAppBarColorDarkMode : kAppBarColorLightMode,
                      iconBuilder: (value, size, foreground) {
                        final Color iconColor;
                        if (isDark) {
                          iconColor = !foreground ? Colors.white : Colors.black;
                        } else {
                          iconColor = !foreground ? Colors.black : Colors.white;
                        }
                        if (value == DarkModeDM.alwaysDark) {
                          return Icon(
                            Icons.nightlight,
                            color: iconColor,
                          );
                        } else if (value == DarkModeDM.alwaysLight) {
                          {
                            return Icon(
                              Icons.light_mode_outlined,
                              color: iconColor,
                            );
                          }
                        } else {
                          return Icon(
                            Icons.brightness_auto,
                            color: iconColor,
                          );
                        }
                      },
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Behaviour', style: _headersStyle),
                    const Expanded(
                      child: DividerCommon(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Auto paste from clipboard',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize),
                    ),
                    const Spacer(),
                    Checkbox(
                        value: state.isPasteFromClipboard,
                        onChanged: (v) =>
                            _onIsPasteFromClipboardChanged(context, v!)),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
