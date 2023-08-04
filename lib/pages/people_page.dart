import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/theme_provider.dart';
import '../utils.dart';
import '../providers/people_provider.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context, listen: true);
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
                titleTextStyle:
                    TextStyle(color: themeProvider.text(), fontSize: 18),
                subtitle: const Text("17 prayers - 6 fasts"),
                trailing: peopleProvider.currentUser == person
                    ? const Icon(Icons.check_circle)
                    : null,
                leading: const Icon(Icons.person),
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
