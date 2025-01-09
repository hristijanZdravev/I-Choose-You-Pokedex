import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import 'details_screen.dart';
import 'random_pokemon_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PokemonProvider>(context, listen: false).fetchPokemonList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = Provider.of<PokemonProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("I Choose You"),
      ),
      body: pokemonProvider.isLoading
          ? Stack(
        children: [
          Container(
            color: Colors.white, // Optional background color
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Centers content vertically
              children: const [
                CircularProgressIndicator(
                  color: Colors.red,
                  strokeWidth: 4.0,
                ),
                SizedBox(height: 20),
                Text(
                  "Loading Pokémon data, please stand by...",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (query) {
                pokemonProvider.filterPokemon(query);
              },
              decoration: InputDecoration(
                hintText: "Search Pokémon...",
                prefixIcon: const Icon(Icons.search, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Pokémon List
            Expanded(
              child: pokemonProvider.pokemonList.isEmpty
                  ? const Center(
                child: Text(
                  "No Pokémon found",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: pokemonProvider.pokemonList.length,
                itemBuilder: (context, index) {
                  final pokemon = pokemonProvider.pokemonList[index];
                  return Card(
                    margin:
                    const EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.red[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.network(
                          pokemon.spriteUrl,
                          errorBuilder: (context, error,
                              stackTrace) =>
                          const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      title: Text(
                        "${pokemon.name.toUpperCase()} #${pokemon.id}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.red,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                                pokemonId: pokemon.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RandomPokemonScreen(),
            ),
          );
        },
        child: const Icon(Icons.casino, color: Colors.white),
      ),
    );
  }
}
