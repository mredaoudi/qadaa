import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:qadaa/providers/fast_provider.dart';
import 'package:qadaa/providers/prayer_provider.dart';
import '../providers/theme_provider.dart';
import '../utils.dart';
import '../providers/people_provider.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  String infoPerson(prayers, fasts) {
    return "$prayers prayers - $fasts fasts";
  }

  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context, listen: true);
    final prayerProvider = Provider.of<PrayerProvider>(context);
    final fastProvider = Provider.of<FastProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor: themeProvider.background(),
        appBar: AppBar(
          foregroundColor: themeProvider.appBarIcon(),
          title: const Icon(Icons.person),
          backgroundColor: themeProvider.appbar(),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            for (String person in peopleProvider.getPeople())
              ListTile(
                title: Text(
                  person,
                ),
                titleTextStyle: TextStyle(
                    color: themeProvider.personName(),
                    fontSize: 18,
                    fontWeight: peopleProvider.currentUser == person
                        ? FontWeight.w500
                        : null),
                subtitle: Text(
                  infoPerson(
                    prayerProvider.amountPrayersUser(user: person),
                    fastProvider.amountFastsUser(user: person),
                  ),
                ),
                subtitleTextStyle: TextStyle(color: themeProvider.text()),
                trailing: peopleProvider.currentUser == person
                    ? Icon(
                        Icons.check_circle,
                        color: themeProvider.text(),
                      )
                    : null,
                leading: Icon(
                  Icons.person,
                  color: themeProvider.text(),
                ),
                onTap: () {
                  if (person != peopleProvider.currentUser) {
                    peopleProvider.setCurrentUser(person);
                    prayerProvider.setup(person);
                    fastProvider.setup(person);
                  }
                },
                onLongPress: () {},
              )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
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
                              style: const TextStyle(color: Colors.red),
                            ),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z]")),
                            ],
                            onChanged: (value) {
                              setState(() {
                                name = value;
                                if (existingPeople.contains(serverName(name))) {
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
                            decoration: const InputDecoration(hintText: 'Name'),
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
                            var modifiedName = serverName(name);
                            if (!existingPeople.contains(modifiedName)) {
                              peopleProvider.createPerson(name: modifiedName);
                              if (peopleProvider.getPeople().length == 1) {
                                peopleProvider.setCurrentUser(modifiedName);
                                prayerProvider.setup(modifiedName);
                                fastProvider.setup(modifiedName);
                              }
                              Navigator.of(context, rootNavigator: true)
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
            );
          },
          backgroundColor: themeProvider.minus(),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ));
  }
}
