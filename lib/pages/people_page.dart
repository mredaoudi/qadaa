import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:qadaa/providers/fast_provider.dart';
import 'package:qadaa/providers/prayer_provider.dart';
import '../providers/theme_provider.dart';
import '../utils.dart';
import '../providers/people_provider.dart';
import '../components/confirm_dialog.dart';

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
    List allPeople = peopleProvider.getPeople();
    return Scaffold(
      backgroundColor: themeProvider.background(),
      appBar: AppBar(
        foregroundColor: themeProvider.appBarIcon(),
        title: const Icon(Icons.people),
        backgroundColor: themeProvider.appbar(),
        centerTitle: true,
      ),
      body: allPeople.isEmpty
          ? Center(
              child: Text(
                "There are no people",
                style: TextStyle(color: themeProvider.text()),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                for (String person in allPeople)
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
                        fastProvider.fasts(user: person),
                      ),
                    ),
                    subtitleTextStyle: TextStyle(
                      color: themeProvider.text(),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (await confirm(
                              context,
                              title: const Text('Reset'),
                              content:
                                  Text('Would you like to reset for $person?'),
                              textOK: const Text('Yes'),
                              textCancel: const Text('No'),
                            )) {
                              prayerProvider.reset(user: person);
                              fastProvider.reset(user: person);
                            }
                            return;
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: themeProvider.text(),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (await confirm(
                              context,
                              title: const Text('Delete'),
                              content:
                                  Text('Would you like to delete $person?'),
                              textOK: const Text('Yes'),
                              textCancel: const Text('No'),
                            )) {
                              peopleProvider.deletePerson(name: person);
                              prayerProvider.deleteUser(user: person);
                              fastProvider.deleteUser(user: person);
                            }
                            return;
                          },
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: themeProvider.plus(),
                          ),
                        ),
                        peopleProvider.currentUser == person
                            ? IconButton(
                                icon: Icon(
                                  Icons.circle,
                                  color: themeProvider.icon(),
                                ),
                                onPressed: null,
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.circle_outlined,
                                  color: themeProvider.text(),
                                ),
                                onPressed: () {
                                  if (person != peopleProvider.currentUser) {
                                    peopleProvider.setCurrentUser(person);
                                  }
                                },
                              ),
                      ],
                    ),
                    leading: peopleProvider.currentUser == person
                        ? Icon(
                            Icons.person,
                            color: themeProvider.icon(),
                          )
                        : Icon(
                            Icons.person_outline,
                            color: themeProvider.text(),
                          ),
                  ),
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
                                  personError = "This username exists already";
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
                            prayerProvider.setup(modifiedName);
                            fastProvider.setup(modifiedName);
                            if (peopleProvider.getPeople().length == 1) {
                              peopleProvider.setCurrentUser(modifiedName);
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
        backgroundColor: themeProvider.button(),
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.person_add,
        ),
      ),
    );
  }
}
