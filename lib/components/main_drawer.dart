import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 128,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF4E6E81),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Roboto-Regular'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => {
              showAboutDialog(
                context: context,
                applicationName: 'Qadaa',
                applicationIcon: Image.asset(
                  'assets/icon/icon.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.scaleDown,
                  alignment: FractionalOffset.center,
                ),
                applicationVersion: '1.0.0',
                applicationLegalese: 'GNU General Public License, version 3.0',
                children: [
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            style: textStyle,
                            text:
                                "Qadaa is an application made to help Muslims fulfill"
                                'their duties that they missed, like prayers and fasts. '
                                'Qadaa is part of the Ahlulbayt.app network.\n'),
                        TextSpan(
                            style: textStyle.copyWith(
                                color: theme.colorScheme.primary),
                            text: 'https://ahlulbayt.app'),
                      ],
                    ),
                  ),
                ],
              ),
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_2_outlined),
            title: const Text('People (coming soon)'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color_outlined),
            title: const Text('Testament (coming soon)'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('Save Online (coming soon)'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
