import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countries Graph',
      home: CountriesScreen(),
    );
  }
}

class CountriesScreen extends StatefulWidget {
  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  String selectedRegion = 'Africa'; // Región predeterminada
  List countries = [];

  // URL de la API GraphQL
  final String url = 'https://countries.trevorblades.com/';

  // Realiza una consulta GraphQL para obtener países de la región seleccionada
  Future<void> fetchCountriesByRegion(String region) async {
    final String query = """
      query {
        countries(filter: {region: "$region"}) {
          name
          capital
          emoji
        }
      }
    """;

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': query,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        countries = data['data']['countries'];
      });
    } else {
      throw Exception('Failed to load countries');
    }
  }

  @override
  void initState() {
    super.initState();
    // Cargar países por defecto
    fetchCountriesByRegion(selectedRegion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countries Graph'),
      ),
      body: Column(
        children: [
          // Selector de región
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedRegion,
              onChanged: (String? newRegion) {
                setState(() {
                  selectedRegion = newRegion!;
                  countries.clear(); // Limpiar países previos
                });
                fetchCountriesByRegion(selectedRegion); // Realizar consulta
              },
              items: ['Africa', 'Americas', 'Asia', 'Europe', 'Oceania']
                  .map((region) => DropdownMenuItem<String>(
                        value: region,
                        child: Text(region),
                      ))
                  .toList(),
            ),
          ),
          // Mostrar lista de países
          Expanded(
            child: countries.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      final country = countries[index];
                      return ListTile(
                        leading: Text(country['emoji'],
                            style: TextStyle(fontSize: 30)),
                        title: Text(country['name']),
                        subtitle: Text('Capital: ${country['capital']}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
