import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    return Drawer(
      backgroundColor: themeProvider.background(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 150,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: themeProvider.appbar(),
              ),
              child: const Text(
                'قضاء',
                style: TextStyle(
                    color: Color(0xffF9DBBB),
                    fontSize: 40,
                    fontFamily: 'Amiri'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.wb_sunny, color: themeProvider.icon()),
            title: Text(themeProvider.isLight() ? 'Dark mode' : 'Light mode',
                style: TextStyle(color: themeProvider.text())),
            onTap: () async {
              themeProvider.changeTheme();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: themeProvider.icon()),
            title: Text('About', style: TextStyle(color: themeProvider.text())),
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
                                "Qadaa is an application made to help Muslims fulfill "
                                'their duties that they missed, like prayers and fasts. '),
                      ],
                    ),
                  ),
                ],
              ),
            },
          ),
        ],
      ),
    );
  }
}
