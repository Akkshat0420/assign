import 'dart:convert';
import 'package:assign/HomeScr.dart';
import 'package:flutter/material.dart';
import 'package:assign/confir_m.dart';
//import 'package:assign/home_view.dart';
import 'package:assign/login.dart';
import 'package:http/http.dart' as http;

class SplashService {
  Future<void> isLogin(BuildContext context) async {
    final Uri url = Uri.parse("http://40.90.224.241:5000/isLoggedIn");

    try {
      final response = await http.get(url, headers: {});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["isLoggedIn"] == true) {
          if (data["user"]["userName"] == null ||
              data["user"]["userName"].isEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ConfirmScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FetchProductsPage()),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      print("Error: $e");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
}
