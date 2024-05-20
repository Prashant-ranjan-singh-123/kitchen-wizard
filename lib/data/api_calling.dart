import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:recipie_app/shared/Api.dart';

class ApiCalling{
  final dio = Dio();

  Future<List<Map<String, dynamic>>> findRecipesByIngredients({
    required List<String> ingredients,
    int number = 5,
    bool limitLicense = true,
    int ranking = 1,
    bool ignorePantry = true,
  }) async {
    final String baseUrl = 'https://api.spoonacular.com/recipes/findByIngredients';
    final String apiKey = ApiKey.privateKey;

    try {
      final dio = Dio();
      final response = await dio.get(baseUrl, queryParameters: {
        'ingredients': ingredients.join(','),
        'number': number,
        'limitLicense': limitLicense,
        'ranking': ranking,
        'ignorePantry': ignorePantry,
        'apiKey': apiKey,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Map<String, dynamic>> recipes = [];

        for (var recipe in data) {
          var details = await _getRecipeDetails(recipe['id']);
          if (details != null) {
            Map<String, dynamic> recipeData = {
              'id': details['id'],
              'title': details['title'],
              'image': details['image'],
              'description': _extractShortDescription(details['summary']),
            };

            // Print all fields
            print('id: ${recipeData['id']}');
            print('title: ${recipeData['title']}');
            print('image: ${recipeData['image']}');
            print('description: ${recipeData['description']}');
            print('');

            recipes.add(recipeData);
          }
        }

        return recipes;
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>?> _getRecipeDetails(int recipeId) async {
    final String baseUrl = 'https://api.spoonacular.com/recipes/$recipeId/information';
    final String apiKey = ApiKey.privateKey;

    try {
      final dio = Dio();
      final response = await dio.get(baseUrl, queryParameters: {
        'apiKey': apiKey,
      });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load recipe details');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  String _extractShortDescription(String summary) {
    // Remove HTML tags
    summary = summary.replaceAll(RegExp(r'<[^>]*>'), '');
    // Trim excess spaces and new lines
    summary = summary.trim();
    // Take the first 100 characters as short description
    return summary.length > 100 ? summary.substring(0, 100) + '...' : summary;
  }


  Future<List<Map<String, dynamic>>> getHttp(List<String> ingredientsList) async {
    return findRecipesByIngredients(
        ingredients: ingredientsList
    );
  }


  Future<List<Map<String, dynamic>>> returnToSavedScreen(List<String> list) async {
    List<Map<String, dynamic>> returnType = [];
    for (int i = 0; i < list.length; ++i) {
      Map<String, dynamic> recipeInfo = await getRecipeInformationSaved(int.parse(list[i]));
      returnType.add(recipeInfo);
    }
    return returnType;
  }

  Future<Map<String, dynamic>> getRecipeInformationSaved(int recipeId) async {
    final String url = 'https://api.spoonacular.com/recipes/$recipeId/information?includeNutrition=true';

    final Dio dio = Dio();

    try {
      final response = await dio.get(url, options: Options(
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': ApiKey.privateKey,
          'stepBreakdown' : true
        },
      ));

      if (response.statusCode == 200) {
        final data = response.data;

        final imageUrl = data['image'];
        final name = data['title'];
        final int id = data['id'];
        final String summary = _extractShortDescription(data['summary']);

        return {
          'name': name,
          'image': imageUrl,
          'id': id,
          'summary': summary,
        };
      } else {
        throw Exception('Failed to load recipe information');
      }
    } on DioError catch (e) {
      print('Error: $e');
      throw Exception('Failed to load recipe information');
    }
  }

  Future<Map<String, dynamic>> getRecipeInformation(int recipeId) async {
    final String url = 'https://api.spoonacular.com/recipes/$recipeId/information?includeNutrition=true';

    final Dio dio = Dio();

    try {
      final response = await dio.get(url, options: Options(
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': ApiKey.privateKey,
          'stepBreakdown' : true
        },
      ));

      // print('length: ${response2.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        final nutrition = data['nutrition'];
        final nutrients = nutrition['nutrients'];

        double calories = 0.0;
        double protein = 0.0;
        double fat = 0.0;

        for (var nutrient in nutrients) {
          switch (nutrient['name']) {
            case 'Calories':
              calories = nutrient['amount'];
              break;
            case 'Protein':
              protein = nutrient['amount'];
              break;
            case 'Fat':
              fat = nutrient['amount'];
              break;
          }
        }

        String summary = data['summary'];
        String cookingInstruction = data['instructions'];
        final imageUrl = data['image'];

        return {
          'calories': calories,
          'protein': protein,
          'fat': fat,
          'summary': summary,
          'cookingInstruction': cookingInstruction,
          'image': imageUrl,
        };
      } else {
        throw Exception('Failed to load recipe information');
      }
    } on DioError catch (e) {
      print('Error: $e');
      throw Exception('Failed to load recipe information');
    }
  }
}