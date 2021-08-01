/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 31.07.21, 23:28.
 * Copyright (c) 2021 EffnerApp.
 */

class SubstitutionItem {
  final String teacher, period, subTeacher, room, info;

  SubstitutionItem(this.teacher, this.period, this.subTeacher, this.room, this.info);
}

class ClassEntry {
  final String name;
  final List<SubstitutionItem>? items;

  ClassEntry(this.name, this.items);
}

class AbsentClass {
  final String date, sClass, period;

  AbsentClass(this.date, this.sClass, this.period);
}

class Substitutions {
  final List<String> dates;
  final Map<String, List<ClassEntry>> days;
  final List<AbsentClass> absentClasses;

  Substitutions(this.dates, this.days, this.absentClasses);
}