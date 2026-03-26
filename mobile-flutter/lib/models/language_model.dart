class Language {
  final String id;
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final bool isActive;

  Language({
    required this.id,
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.isActive,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      nativeName: json['nativeName'],
      flag: json['flag'] ?? '',
      isActive: json['isActive'],
    );
  }
}