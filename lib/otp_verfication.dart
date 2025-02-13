import 'dart:convert';
import 'dart:async';
import 'package:assign/confir_m.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String countryCode;
  final String mobileNumber;

  OtpVerificationScreen({
    required this.countryCode,
    required this.mobileNumber,
  });

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  int _remainingSeconds = 30;
  late Timer _timer;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingSeconds = 30;
    _isResendEnabled = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer.cancel();
        setState(() => _isResendEnabled = true);
      }
    });
  }

  Future<void> verifyOtp() async {
    final String otp = otpController.text.trim();

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid 4-digit OTP")),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse("http://40.90.224.241:5000/login/otpValidate");

    final Map<String, dynamic> requestData = {
      "countryCode": int.parse(widget.countryCode),
      "mobileNumber": int.parse(widget.mobileNumber),
      "otp": int.parse(otp),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody["status"] == "SUCCESS") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("OTP Verified Successfully!")),
          );
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ConfirmScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseBody["reason"] ?? "Invalid OTP")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Verify OTP",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(height: 8),
            Text("Enter the OTP sent to ${widget.mobileNumber}",
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 30),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 4,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                counterText: "",
                hintText: "Enter OTP",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {});
                if (value.length == 4) {
                  verifyOtp();
                }
              },
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed:
                        otpController.text.length == 4 ? verifyOtp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Verify",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
            SizedBox(height: 20),
            _isResendEnabled
                ? TextButton(
                    onPressed: () {
                      _startTimer();
                      // Add resend OTP logic here
                    },
                    child: Text("Resend OTP",
                        style:
                            TextStyle(fontSize: 16, color: Colors.deepPurple)),
                  )
                : Text("Resend in $_remainingSeconds sec",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
