/*
 * Developed by Sebastian Müller and Luis Bros.
 * Last updated: 27.07.21, 20:28.
 * Copyright (c) 2021 EffnerApp.
 */

class MOTD {
  final String motd;

  MOTD(this.motd);

  MOTD.fromJson(Map<String, dynamic> json)
      : motd = json['motd'];

  Map<String, dynamic> toJson() => {
    'motd': motd
  };
}