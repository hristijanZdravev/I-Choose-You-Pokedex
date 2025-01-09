import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokemonApiService {
  // Singleton implementation
  PokemonApiService._privateConstructor();
  static final PokemonApiService instance = PokemonApiService._privateConstructor();

  final String baseUrl = "https://pokeapi.co/api/v2";

  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=1025'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json['results'] as List;
      return results.asMap().entries.map((entry) {
        final id = entry.key + 1; // IDs are 1-indexed
        final name = entry.value['name'];
        final spriteUrl =
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";
        return Pokemon(
          id: id,
          name: name,
          spriteUrl: spriteUrl,
          types: [], // Type domain not available in this endpoint
          abilities: [], // Abilities domain not available
          stats: {}, // Stats domain not available
          speciesId: 0,
        );
      }).toList();
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }

  Future<Pokemon> fetchPokemonDetails(int pokemonId) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$pokemonId'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Pokemon.fromJson(json);
    } else {
      throw Exception("Failed to fetch Pokémon details");
    }
  }

  Future<Pokemon> fetchRandomPokemon() async {
    final randomId = (1 + (1025 - 1) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).floor();
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$randomId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Pokemon.fromJson(json);
    } else {
      throw Exception("Failed to fetch random Pokémon");
    }
  }

  Future<List<String>> fetchEvolutionChain(int speciesId) async {
    try {
      // Fetch species details to get the evolution chain URL
      final speciesResponse = await http.get(Uri.parse('$baseUrl/pokemon-species/$speciesId'));
      if (speciesResponse.statusCode != 200) {
        throw Exception('Failed to fetch species domain');
      }

      final speciesData = jsonDecode(speciesResponse.body);
      final evolutionChainUrl = speciesData['evolution_chain']['url'];

      // Fetch evolution chain domain
      final evolutionResponse = await http.get(Uri.parse(evolutionChainUrl));
      if (evolutionResponse.statusCode != 200) {
        throw Exception('Failed to fetch evolution chain domain');
      }

      final evolutionData = jsonDecode(evolutionResponse.body);
      List<String> evolutionNames = [];
      var chain = evolutionData['chain'];

      // Traverse the evolution chain
      while (chain != null) {
        evolutionNames.add(chain['species']['name']);
        chain = chain['evolves_to'].isNotEmpty ? chain['evolves_to'][0] : null;
      }

      // Check if the chain contains more than just the Pokémon itself
      return evolutionNames.length > 1 ? evolutionNames : [];
    } catch (e) {
      throw Exception('Error fetching evolution chain: $e');
    }
  }

}
