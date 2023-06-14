import 'dart:convert';

class Entry {
  String? owner;
  bool noSymptoms;
  bool fever;
  bool feelingFeverish;
  bool muscleOrJointPains;
  bool cough;
  bool colds;
  bool soreThroat;
  bool difficultyOfBreathing;
  bool diarrhea;
  bool lossOfTaste;
  bool lossOfSmell;
  String isInContact;
  String date;

  Entry({
    this.owner,
    required this.noSymptoms,
    required this.fever,
    required this.feelingFeverish,
    required this.muscleOrJointPains,
    required this.cough,
    required this.colds,
    required this.soreThroat,
    required this.difficultyOfBreathing,
    required this.diarrhea,
    required this.lossOfTaste,
    required this.lossOfSmell,
    required this.isInContact,
    required this.date,
  });

  // Factory constructor to instantiate object from json format
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
        owner: json["owner"],
        noSymptoms: json['noSymptoms'],
        fever: json['fever'],
        feelingFeverish: json['feelingFeverish'],
        muscleOrJointPains: json['muscleOrJointPains'],
        cough: json['cough'],
        colds: json['colds'],
        soreThroat: json['soreThroat'],
        difficultyOfBreathing: json['difficultyOfBreathing'],
        diarrhea: json['diarrhea'],
        lossOfTaste: json['lossOfTaste'],
        lossOfSmell: json['lossOfSmell'],
        isInContact: json['isInContact'],
        date: json['date']);
  }

  static List<Entry> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Entry>((dynamic d) => Entry.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "owner": owner,
      "noSymptoms": noSymptoms,
      "fever": fever,
      "feelingFeverish": feelingFeverish,
      "muscleOrJointPains": muscleOrJointPains,
      "cough": cough,
      "colds": colds,
      "soreThroat": soreThroat,
      "difficultyOfBreathing": difficultyOfBreathing,
      "diarrhea": diarrhea,
      "lossOfTaste": lossOfTaste,
      "lossOfSmell": lossOfSmell,
      "isInContact": isInContact,
      "date": date,
    };
  }
}
