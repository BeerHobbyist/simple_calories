import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'calories_estimator_model.dart'; // Make sure this class is defined in your project

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CaloriesEstimatorModel(),
      child: MaterialApp(
        title: 'Simple Calories',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.cyanAccent, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Simple Calories Estimator'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _foodName;

  void _updateFoodName(String value) {
    setState(() {
      _foodName = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => _updateFoodName(value),
                  decoration: const InputDecoration(
                    labelText: 'Enter food description here',
                    hintText: 'e.g., A slice of pepperoni pizza',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.fastfood),
                  ),
                ),
                const SizedBox(height: 20), // Add spacing
                ElevatedButton(
                  onPressed: () => context
                      .read<CaloriesEstimatorModel>()
                      .estimateCalories(_foodName),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Estimate Calories'),
                ),
                const SizedBox(height: 20), // Add spacing before the list
                Expanded(
                  child: Consumer<CaloriesEstimatorModel>(
                    builder: (context, model, child) {
                      return ListView.builder(
                        itemCount: model.estimatedCaloriesTextList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                model.estimatedCaloriesTextList[index],
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: const Icon(Icons.check_circle_outline),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            )));
  }
}
