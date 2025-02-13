import 'dart:convert';
import 'package:assign/HomeScr.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> brands = [];

  @override
  void initState() {
    super.initState();
    fetchBrands();
  }

  void _confirmName() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FetchProductsPage()));
  }

  Future<void> fetchBrands() async {
    final response =
        await http.get(Uri.parse('http://40.90.224.241:5000/makeWithImages'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        brands = data['dataObject'];
      });
    } else {
      print('Failed to load brands');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Brands')),
      body: brands.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: brands.map((brand) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Image.network(
                                brand['imagePath'],
                                width: 80,
                                height: 80,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.image_not_supported,
                                      size: 80);
                                },
                              ),
                              SizedBox(height: 5),
                              Text(
                                brand['make'],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                onPressed: _confirmName,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Next",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward, size: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
