class Pokemon {
  final int id;
  final String name;
  final String spriteUrl;
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;
  final int speciesId; // New field for species ID

  Pokemon({
    required this.id,
    required this.name,
    required this.spriteUrl,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.speciesId, // Initialize speciesId
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      spriteUrl: json['sprites']['front_default'],
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      abilities: (json['abilities'] as List)
          .map((ability) => ability['ability']['name'] as String)
          .toList(),
      stats: {
        for (var stat in json['stats'])
          stat['stat']['name']: stat['base_stat'] as int,
      },
      speciesId: _extractSpeciesId(json['species']['url']),
    );
  }

  // Extract the species ID from the species URL
  static int _extractSpeciesId(String url) {
    final segments = url.split('/');
    return int.parse(segments[segments.length - 2]);
  }
}
