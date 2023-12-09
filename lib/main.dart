import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'meal_categories.dart';

const apiUrl = 'https://www.themealdb.com/api/json/v1/1/categories.php';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Title',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData != null && responseData['categories'] != null) {
          setState(() {
            categories = List<Map<String, dynamic>>.from(responseData['categories']);
          });
        } else {
          print('Error: No categories found in the response');
        }
      } else {
        print('Error: Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Categories'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            color: Colors.blueAccent,
            child: ListTile(
              title: Text(category['strCategory'] ?? ''),
              subtitle: Text(category['strCategoryDescription'] ?? ''),
              leading: category['strCategoryThumb'] != null
                  ? SizedBox(
                width: 80.0,
                height: 80.0,
                child: Image.network(
                  category['strCategoryThumb'],
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                width: 80.0,
                height: 80.0,
                color: Colors.grey,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealCategoryPage(category: category['strCategory']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
