/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 27.07.21, 15:31.
 * Copyright (c) 2021 EffnerApp.
 */

import 'package:effnerapp/utils/json/substitution/Substitution.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:dsbmobile/dsbmobile.dart';

class Substitution extends StatefulWidget {
  const Substitution({Key? key}) : super(key: key);

  @override
  _SubstitutionState createState() => _SubstitutionState();
}

class _SubstitutionState extends State<Substitution> {
  late Future<Substitutions> substitutions;

  @override
  void initState() {
    super.initState();
    substitutions = fetchSubstitutions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<Substitutions>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final substitutions = data.days['28.07.2021']!.firstWhere((entry) => entry.name == '11Q').items;

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: substitutions!
                          .map((entry) => Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                          color: const Color(0xff4b4c50),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              material.Text(
                                                formatSubstitution(entry),
                                                style: const TextStyle(
                                                    color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              material.Text(
                                                'Ausfall: ' + entry.teacher,
                                                style: const TextStyle(
                                                    color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              material.Text(
                                                'Vertretung: ' + entry.subTeacher,
                                                style: const TextStyle(
                                                    color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              material.Text(
                                                'Info: ' + entry.info,
                                                style: const TextStyle(
                                                    color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ))
                          .toList());
                  // return material.Text(
                  //   snapshot.data!.,
                  //   textAlign: TextAlign.center,
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 22.0,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // );
                } else if (snapshot.hasError) {
                  return material.Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }
                return material.Text(
                  'Loading ...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
              future: substitutions)),
    );
  }
}

Future<String?> getSClass() async {
  final storage = FlutterSecureStorage();
  return await storage.read(key: 'class');
}

Future<Substitutions> fetchSubstitutions() async {
  final storage = FlutterSecureStorage();
  final credentials = (await storage.read(key: 'credentials'))!.split(':');

  final dsbApi = DSBApi(credentials[0], credentials[1]);

  await dsbApi.login();

  final timetables = await dsbApi.getTimetables();

  if (timetables.isEmpty) {
    throw Exception('Could not fetch timetables from dsbmobile');
  }

  // final timetable = (timetables[0] as DSBTimetable);

  final response = await http.get(Uri.parse(timetables[0]['Detail']));

  final document = parse(response.body);

  final documents = splitDocuments(document);

  final dates = <String>[];

  final days = Map<String, List<ClassEntry>>();

  final information = Map();

  final absentClasses = <AbsentClass>[];

  documents.forEach((document) {
    final date = document.querySelector('a')!.attributes['name'];

    if (date != null) {
      dates.add(date);
    }

    document.querySelectorAll('table').forEach((table) {
      switch (table.attributes['class']) {
        case 'F':
          if (table.text.trim().isNotEmpty) {
            information.putIfAbsent(date, () => table.querySelectorAll('th').map((th) => th.text.trim()).join('\n'));
          }
          break;
        case 'K':
          absentClasses.addAll(table
              .querySelectorAll('tr')
              .where((tr) => tr.querySelector('th') != null && tr.querySelector('td') != null)
              .map((tr) =>
                  AbsentClass(date!, tr.querySelector('th')!.text.trim(), tr.querySelector('td')!.text.trim())));
          break;
        case 'k':
          days.putIfAbsent(
              date!,
              () => table
                      .querySelectorAll('tbody')
                      .where((tbody) => !tbody.text.trim().startsWith('Klasse'))
                      .map((tbody) {
                    final items = tbody.querySelectorAll('tr').map((tr) {
                      final td = tr.querySelectorAll('td');

                      return SubstitutionItem(td[0].text.trim(), td[1].text.trim(), td[2].text.trim(),
                          td[3].text.trim(), td[4].text.trim());
                    }).toList();

                    return ClassEntry(tbody.querySelector('th')!.text.trim(), items);
                  }).toList());
          break;
      }
    });
  });

  return Substitutions(dates, days, absentClasses);
}

// adopted from https://github.com/EffnerApp/effmnerapp-web/blob/master/src/tools/dsbmobile/index.ts#L164
List<Document> splitDocuments(Document document) {
  final elements = <String>[];

  document.querySelectorAll('a').forEach((a) {
    if (a.attributes.containsKey('name') && a.attributes['name'] != 'oben') {
      elements.add(a.outerHtml);
    }
  });

  final documents = <Document>[];

  final outer = document.documentElement!.outerHtml;

  for (int i = 0; i < elements.length; i++) {
    if (i == elements.length - 1) {
      documents.add(parse(outer.substring(outer.indexOf(elements[i]))));
    } else {
      documents.add(parse(outer.substring(outer.indexOf(elements[i]), outer.indexOf(elements[i + 1]))));
    }
  }

  return documents;
}

String formatSubstitution(SubstitutionItem item) {
  return item.period.toString() +
      '. Stunde' +
      (item.teacher.isNotEmpty ? ' (' + item.teacher + ')' : '') +
      (item.info == 'Raumänderung'
          ? ': Raumänderung zu Raum ' + item.room
          : ((item.subTeacher.isNotEmpty
              ? ' vertreten durch ' + item.subTeacher
              : (item.info.isNotEmpty ? ': ' + item.info : ''))));
}
