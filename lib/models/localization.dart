class Localization {

  String name;
  String localized;
  Map<String, String> translations;

  String resolve(String key) {
    return translations[key] ?? "No translation found";
  }

  //<editor-fold desc="Data Methods">

  Localization({
    required this.name,
    required this.localized,
    required this.translations,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Localization &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          localized == other.localized &&
          translations == other.translations);

  @override
  int get hashCode =>
      name.hashCode ^ localized.hashCode ^ translations.hashCode;

  @override
  String toString() {
    return 'Localization{' +
        ' name: $name,' +
        ' localized: $localized,' +
        ' translations: $translations,' +
        '}';
  }

  Localization copyWith({
    String? name,
    String? localized,
    Map<String, String>? translations,
  }) {
    return Localization(
      name: name ?? this.name,
      localized: localized ?? this.localized,
      translations: translations ?? this.translations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'localized': this.localized,
      'translations': this.translations,
    };
  }

  factory Localization.fromMap(Map<String, dynamic> map) {
    return Localization(
      name: map['name'] as String,
      localized: map['localized'] as String,
      translations: (map['translations'] as Map<String, dynamic>).cast(),
    );
  }

//</editor-fold>
}