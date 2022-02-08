class Attributes {
  String? traitType;
  String? value;

  Attributes({this.traitType, this.value});

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      Attributes(
        traitType: json['trait_type'],
        value: json['value'].toString(),
      );


  Map<String, dynamic> toJson() =>
      {
        "traitType": traitType,
        "value": value,
      };
}