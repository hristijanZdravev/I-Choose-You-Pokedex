import 'package:flutter/material.dart';
import '../../domain/models/pokemon_model.dart';
import '../../domain/services/pokemon_api_service.dart';


class PokemonProvider with ChangeNotifier {
  final PokemonApiService _apiService = PokemonApiService.instance;

  List<Pokemon> _pokemonList = [];
  List<Pokemon> _filteredPokemonList = [];
  Pokemon? _randomPokemon;
  Pokemon? _pokemonDetails;
  List<String> _evolutionChain = [];


  bool _isLoading = false;
  bool _isEvolutionLoading = false;
  bool _isRandomLoading = false;
  bool _isDetailsLoading = false;

  Pokemon? get randomPokemon => _randomPokemon;
  bool get isRandomLoading => _isRandomLoading;

  Pokemon? get pokemonDetails => _pokemonDetails;
  bool get isDetailsLoading => _isDetailsLoading;

  List<Pokemon> get pokemonList => _filteredPokemonList;
  bool get isLoading => _isLoading;

  List<String> get evolutionChain => _evolutionChain;
  bool get isEvolutionLoading => _isEvolutionLoading;

  Future<void> fetchPokemonList() async {
    _isLoading = true;
    notifyListeners();
    try {
      _pokemonList = await _apiService.fetchPokemonList();
      _filteredPokemonList = List.from(_pokemonList);
    } catch (error) {
      print("Error fetching Pokémon list: $error");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchRandomPokemon() async {
    _isRandomLoading = true;
    notifyListeners();
    try {
      _randomPokemon = await _apiService.fetchRandomPokemon();
    } catch (error) {
      print("Error fetching random Pokémon: $error");
    }
    _isRandomLoading = false;
    notifyListeners();
  }

  Future<void> fetchPokemonDetails(int pokemonId) async {
    _isDetailsLoading = true;
    notifyListeners();
    try {
      final details = await _apiService.fetchPokemonDetails(pokemonId);
      _pokemonDetails = details;

      // Fetch evolution chain after fetching details
      if (details.speciesId > 0) {
        await fetchEvolutionChain(details.speciesId);
      }
    } catch (error) {
      print("Error fetching Pokémon details: $error");
    }
    _isDetailsLoading = false;
    notifyListeners();
  }


  void filterPokemon(String query) {
    if (query.isEmpty) {
      _filteredPokemonList = List.from(_pokemonList);
    } else {
      _filteredPokemonList = _pokemonList
          .where((pokemon) => pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> fetchEvolutionChain(int speciesId) async {
    _isEvolutionLoading = true;
    notifyListeners();
    try {
      _evolutionChain = await _apiService.fetchEvolutionChain(speciesId);
    } catch (error) {
      print("Error fetching evolution chain: $error");
      _evolutionChain = [];
    }
    _isEvolutionLoading = false;
    notifyListeners();
  }
}
