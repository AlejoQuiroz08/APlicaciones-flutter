import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PokemonPage(),
    );
  }
}

class PokemonPage extends StatefulWidget {
  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  bool isLoading = false;
  List<Map<String, dynamic>> pokemons = [];
  TextEditingController searchController = TextEditingController();

  // Mapa de colores para cada tipo de Pokémon
  final Map<String, Color> typeColors = {
    'fire': Colors.red,
    'water': Colors.blue,
    'grass': Colors.green,
    'electric': Colors.yellow,
    'psychic': Colors.purple,
    'normal': Colors.grey,
    'bug': Colors.greenAccent,
    'ghost': Colors.deepPurple,
    'fairy': Colors.pink,
    'fighting': Colors.orange,
    'poison': Colors.purpleAccent,
    'ground': Colors.brown,
    'rock': Colors.grey,
    'dragon': Colors.blueAccent,
    'dark': Colors.black,
    'steel': Colors.blueGrey,
    'ice': Colors.lightBlue,
    'flying': Colors.lightBlueAccent,
  };

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchPokemon(String name) async {
    setState(() {
      isLoading = true;
    });

    final url = 'https://pokeapi.co/api/v2/pokemon/$name';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Map<String, dynamic> pokemon = await fetchPokemonDetails(data['id']);
      setState(() {
        pokemons = [pokemon];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showError('Pokémon not found');
    }
  }

  Future<Map<String, dynamic>> fetchPokemonDetails(int id) async {
    final url = 'https://pokeapi.co/api/v2/pokemon/$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> types = (data['types'] as List?)
              ?.map((type) => type['type']['name'] as String)
              .toList() ??
          [];

      List<Map<String, dynamic>> stats = (data['stats'] as List)
          .map((stat) => {
                'stat': stat['stat']['name'],
                'base_stat': stat['base_stat'],
              })
          .toList();

      return {
        'name': data['name'],
        'image':
            data['sprites']['other']['official-artwork']['front_default'] ?? '',
        'types': types,
        'stats': stats,
      };
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Función para obtener el color de la barra según el valor de la estadística
  Color getStatColor(int statValue) {
    int green = (statValue > 100) ? 255 : (statValue * 2.55).toInt();
    int red = (statValue < 100) ? 255 : (255 - (statValue * 0.255).toInt());
    return Color.fromRGBO(red, green, 0, 1);
  }

  // Función para obtener el color del tipo de Pokémon
  Color getTypeColor(String type) {
    return typeColors[type] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Enter Pokémon Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  fetchPokemon(value.toLowerCase());
                }
              },
            ),
          ),
          if (isLoading && pokemons.isEmpty)
            Center(child: CircularProgressIndicator()),
          if (!isLoading && pokemons.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: pokemons.length,
                itemBuilder: (context, index) {
                  final pokemon = pokemons[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              pokemon['image'] != null
                                  ? Image.network(
                                      pokemon['image'],
                                      width: 50,
                                      height: 50,
                                    )
                                  : CircularProgressIndicator(),
                              SizedBox(width: 10),
                              Text(
                                pokemon['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Types:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: pokemon['types'].map<Widget>((type) {
                              return Container(
                                margin: EdgeInsets.only(right: 5),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: getTypeColor(type),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Stats:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: pokemon['stats'].map<Widget>((stat) {
                              int statValue = stat['base_stat'];
                              return Column(
                                children: [
                                  Text(stat['stat'],
                                      style: TextStyle(fontSize: 14)),
                                  SizedBox(height: 5),
                                  LinearProgressIndicator(
                                    value: statValue / 255, // Escalado de 0 a 1
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      getStatColor(statValue),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${statValue}', // Mostrar el número de la estadística
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (!isLoading && pokemons.isEmpty)
            Center(
              child: Text(
                'No Pokémon found. Try searching by name.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
