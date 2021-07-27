class MOTD {
  final String motd;

  MOTD(this.motd);

  MOTD.fromJson(Map<String, dynamic> json)
      : motd = json['motd'];

  Map<String, dynamic> toJson() => {
    'motd': motd
  };
}