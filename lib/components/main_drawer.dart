import 'package:flutter/material.dart';
import '../providers/people_provider.dart';
import '../providers/prayer_provider.dart';
import '../providers/fast_provider.dart';
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
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(
            height: 150,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF4E6E81),
              ),
              child: Text(
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
              title: const Text('People'),
              leading: Icon(_isExpanded ? Icons.people_outline : Icons.people),
              trailing: Icon(_isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              children: <Widget>[
                ...peopleProvider
                    .getPeople()
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(left: 30, right: 60),
                        child: ListTile(
                          leading: e == peopleProvider.currentUser
                              ? const Icon(Icons.how_to_reg)
                              : const Icon(Icons.person_outline),
                          title: Text(capitalize(e)),
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
                    title: const Icon(
                      Icons.add_circle_outlined,
                      size: 24,
                    ),
                    onTap: () => {
                      showDialog(
                        context: context,
                        builder: (_) {
                          var messageController = TextEditingController();
                          return AlertDialog(
                            title: const Text('Add a new person'),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: messageController,
                                    decoration:
                                        const InputDecoration(hintText: 'Name'),
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
                                  var message = messageController.text;
                                  if (message.isNotEmpty) {
                                    peopleProvider.createPerson(name: message);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  }
                                },
                                child: const Text('Create'),
                              ),
                            ],
                          );
                        },
                      )
                    },
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('Save counters'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.wb_sunny),
            title: const Text('Dark mode'),
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
        ],
      ),
    );
  }
}

String capitalize(text) {
  return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
}
