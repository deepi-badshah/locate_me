import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const WarehouseLocatorApp());
}

class WarehouseLocatorApp extends StatelessWidget {
  const WarehouseLocatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warehouse Locator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WarehouseLocatorScreen(),
    );
  }
}

class WarehouseLocatorScreen extends StatefulWidget {
  const WarehouseLocatorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WarehouseLocatorScreenState createState() => _WarehouseLocatorScreenState();
}

class _WarehouseLocatorScreenState extends State<WarehouseLocatorScreen> {
  int n = 0; // Number of cities
  int k = 0; // Number of warehouses

  List<List<int>> distanceMatrix = []; // Distances between cities

  double maxDistance = 0; // Maximum distance from a city to a warehouse
  List<String> selectedCities = []; // Names of selected cities

  List<String> cityNames = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Locate Me!')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              TextFormField(
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Enter the Number of cities',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    n = int.tryParse(value) ?? 0;
                    distanceMatrix =
                        List.generate(n, (index) => List<int>.filled(n, 0));
                  });
                },
              ),
              const SizedBox(height: 30.0),
              const Center(
                child: Text(
                  'Enter the distance matrix:',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 8.0),
              buildDistanceMatrixFields(),
              const SizedBox(height: 30.0),
              TextFormField(
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Number of warehouses',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    k = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (validateInput()) {
                      selectKcities(n, distanceMatrix, k);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Invalid Input'),
                            content: const Text('Please enter valid values.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Find Warehouse Locations'),
                ),
              ),
              const SizedBox(height: 30.0),
              if (maxDistance != 0) ...[
                const Text(
                  'Maximum Distance from any city to Warehouse:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Card(
                  color: Colors.blue.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      maxDistance.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              if (selectedCities.isNotEmpty) ...[
                const SizedBox(height: 16.0),
                const Text(
                  'Selected Cities:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Card(
                  color: Colors.blue.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectedCities
                          .map(
                            (city) => Text(
                              city,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDistanceMatrixFields() {
    return Column(
      children: List.generate(n, (i) {
        return Row(
          children: List.generate(n, (j) {
            return Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      distanceMatrix[i][j] = int.tryParse(value) ?? 0;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: '${cityNames[i]} - ${cityNames[j]}',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  bool validateInput() {
    if (n <= 0 ||
        k <= 0 ||
        distanceMatrix.length != n ||
        distanceMatrix.any((row) => row.length != n)) {
      return false;
    }

    return true;
  }

  void selectKcities(int n, List<List<int>> weights, int k) {
    List<int> dist = List<int>.filled(n, 1000);
    List<int> centers = [];

    int max = 0;
    for (int i = 0; i < k; i++) {
      centers.add(max);
      for (int j = 0; j < n; j++) {
        if (dist[j] != 0) {
          dist[j] = min(dist[j], weights[max][j]);
        }
      }
      max = maxIndex(dist, n);
    }

    maxDistance = dist[max].toDouble();
    selectedCities = centers.map((index) => cityNames[index]).toList();
    setState(() {});
  }

  int maxIndex(List<int> arr, int n) {
    int maxIndex = 0;
    for (int i = 1; i < n; i++) {
      if (arr[i] > arr[maxIndex]) {
        maxIndex = i;
      }
    }
    return maxIndex;
  }
}
