class Info {
  final String name;
  final String value;

  Info({required this.name, required this.value});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
      };
}
