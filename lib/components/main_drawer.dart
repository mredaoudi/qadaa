import 'package:flutter/material.dart';
import '../providers/people_provider.dart';
import '../providers/prayer_provider.dart';
import '../providers/fast_provider.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final prayerProvider = Provider.of<PrayerProvider>(context);
    final fastProvider = Provider.of<FastProvider>(context);
    final peopleProvider = Provider.of<PeopleProvider>(context);
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
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              onExpansionChanged: (b) {
                setState(() {
                  _isExpanded =
                      !_isExpanded; //using set state just to exemplify
                });
              },
              title: Text(
                'People',
                style: TextStyle(color: themeProvider.text()),
              ),
              leading: Icon(
                _isExpanded ? Icons.people_outline : Icons.people,
                color: themeProvider.icon(),
              ),
              trailing: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: themeProvider.icon(),
              ),
              children: <Widget>[
                ...peopleProvider
                    .getPeople()
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(left: 30, right: 60),
                        child: ListTile(
                          leading: e == peopleProvider.currentUser
                              ? Icon(
                                  Icons.how_to_reg,
                                  color: themeProvider.icon(),
                                )
                              : Icon(
                                  Icons.person_outline,
                                  color: themeProvider.icon(),
                                ),
                          title: Text(capitalize(e),
                              style: TextStyle(color: themeProvider.text())),
                          onTap: () async {
                            if (e != peopleProvider.currentUser) {
                              peopleProvider.setCurrentUser(e);
                              prayerProvider.setup(e);
                              fastProvider.setup(e);
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    )
                    .toList(),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 60),
                  child: ListTile(
                    title: Icon(Icons.add_circle_outlined,
                        size: 24, color: themeProvider.icon()),
                    onTap: () => {
                      showDialog(
                        context: context,
                        builder: (_) {
                          List existingPeople = peopleProvider.getPeople();
                          String personError = "";
                          String name = "";
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: const Text('Add a new person'),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    if (personError != "")
                                      Text(
                                        personError,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          name = value;
                                          if (existingPeople.contains(name)) {
                                            setState(() {
                                              personError =
                                                  "This username exists already";
                                            });
                                          } else {
                                            setState(() {
                                              personError = "";
                                            });
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          hintText: 'Name'),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (name.isNotEmpty) {
                                      if (!existingPeople.contains(name)) {
                                        peopleProvider.createPerson(name: name);
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop('dialog');
                                      }
                                    }
                                  },
                                  child: const Text('Create'),
                                ),
                              ],
                            );
                          });
                        },
                      )
                    },
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.save_alt, color: themeProvider.icon()),
            title: Text('Save counters',
                style: TextStyle(color: themeProvider.text())),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.wb_sunny, color: themeProvider.icon()),
            title: Text('Dark mode',
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
        ],
      ),
    );
  }
}

String capitalize(text) {
  return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
}
