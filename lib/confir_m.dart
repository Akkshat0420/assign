import 'package:assign/HomeScr.dart';
import 'package:flutter/material.dart';
//import 'package:assign/home_view.dart';

class ConfirmScreen extends StatefulWidget {
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _confirmName() {
    String name = _nameController.text.trim();
    if (name.isNotEmpty) {
      // Navigate to Home Screen after confirmation
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => FetchProductsPage()));
    } else {
      // Show error if name is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your name")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              "https://i.tracxn.com/logo/company/oruphones.com_Logo_69e0c37a-5144-41ef-8d11-4e38f526032e.jpg",
              height: 200,
              fit: BoxFit.cover,
            ),
            Text(
              "Welcome",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(height: 5),
            Text("SignUp to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Please Tell Us Your Name *",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Name",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
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
                    Text("Confirm Name",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
