import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_food_recipes/model/recipes.dart';
import 'package:http/http.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Recipe> _recipeList = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getRecipeList();
  }

  Future<void> _getRecipeList() async {
    _recipeList.clear();
    _loading = true;
    setState(() {});

    Uri uri = Uri.parse('http://35.73.30.144:2008/api/v1/ReadRecipes');
    
    Response response = await get(uri);

    debugPrint(response.statusCode.toString());
    debugPrint(response.body.toString());

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      for (Map<String, dynamic> recipeJson in decodedJson['recipes']) {
        Recipe recipe = Recipe.fromJson(recipeJson);
        _recipeList.add(recipe);
      }
    }

    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Recipes"),
        backgroundColor: Colors.blue,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _recipeList.length,
              itemBuilder: (context, index) {
                final recipe = _recipeList[index];
                return Row(
                  children: [
                    const Icon(Icons.food_bank),
                    Expanded(
                      child: ListTile(
                        title: Text(recipe.title,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(recipe.description),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
