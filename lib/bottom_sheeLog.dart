import 'package:assign/bottom_veri.dart';
import 'package:flutter/material.dart';
//import 'package:assign/otp_verfication.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginBottomSheet extends StatelessWidget {
  const LoginBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
      ),
      child: LoginForm(),
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LoginBottomSheet(),
    );
  }
}


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController phoneController = TextEditingController();
  bool acceptTerms = false;
  bool isLoading = false;

  Future<void> sendOtp() async {
    final String phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid 10-digit mobile number")),
      );
      return;
    }

    if (!acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must accept the Terms & Conditions")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> requestData = {
      "countryCode": 91,
      "mobileNumber": int.parse(phoneNumber)
    };

    try {
      final response = await http.post(
        Uri.parse("http://40.90.224.241:5000/login/otpCreate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      final responseData = jsonDecode(response.body);
      print("Response: $responseData");

      if (response.statusCode == 200 && responseData["status"] == "SUCCESS") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BottomVerification(
                  countryCode: '91', mobileNumber: phoneNumber)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  responseData["reason"] ?? "Failed to send OTP. Try again.")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error. Please try again.")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            "https://i.tracxn.com/logo/company/oruphones.com_Logo_69e0c37a-5144-41ef-8d11-4e38f526032e.jpg",
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 15),
          Text(
            "Welcome",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("Sign in to continue",
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          SizedBox(height: 25),

         
          Align(
            alignment: Alignment.centerLeft,
            child:
                Text("Enter Your Phone Number", style: TextStyle(fontSize: 16)),
          ),
          SizedBox(height: 8),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixText: "+91 ",
              hintText: "Mobile Number",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 15),

          
          Row(
            children: [
              Checkbox(
                value: acceptTerms,
                onChanged: (value) {
                  setState(() {
                    acceptTerms = value ?? false;
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  
                },
                child: Text(
                  "Accept Terms and Conditions",
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

         
          ElevatedButton(
            onPressed: isLoading ? null : sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Next",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
