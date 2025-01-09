import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import 'details_screen.dart';

class RandomPokemonScreen extends StatefulWidget {
  const RandomPokemonScreen({Key? key}) : super(key: key);

  @override
  State<RandomPokemonScreen> createState() => _RandomPokemonScreenState();
}

class _RandomPokemonScreenState extends State<RandomPokemonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PokemonProvider>(context, listen: false).fetchRandomPokemon();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);
    final isLoading = provider.isRandomLoading;
    final pokemon = provider.randomPokemon;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Pokémon"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pokemon == null
          ? const Center(child: Text("No Pokémon loaded"))
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.red[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.network(
                      pokemon.spriteUrl,
                      height: 150,
                      width: 150,
                    ),
                    Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<PokemonProvider>(context, listen: false)
                    .fetchRandomPokemon();
              },
              child: const Text("Randomize Again"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailsScreen(pokemonId: pokemon.id),
                  ),
                );
              },
              child: const Text("View Details"),
            ),
          ],
        ),
      ),
    );
  }
}
