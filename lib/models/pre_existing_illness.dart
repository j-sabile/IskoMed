class PreExistingIllness {
  List<dynamic> illnesses;
  String? allergies;

  static List<String> illnessChoices = [
    'Hypertension',
    'Diabetes',
    'Tuberculosis',
    'Cancer',
    'Kidney Disease',
    'Cardiac Disease',
    'Autoimmune Disease',
    'Asthma',
    'Allergies',
  ];

  PreExistingIllness({
    required this.illnesses,
    this.allergies,
  });

  Map<String, dynamic> toJson() {
    if (allergies == null) {
      return {"illnesses": illnesses};
    } else {
      return {"illnesses": illnesses, "allergies": allergies};
    }
  }

  factory PreExistingIllness.fromJson(Map<String, dynamic> json) {
    if (json["allergies"] == null) {
      return PreExistingIllness(illnesses: json["illnesses"]);
    } else {
      return PreExistingIllness(illnesses: json["illnesses"], allergies: json["allergies"]);
    }
  }
}
