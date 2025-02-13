import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Expanded(
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    "https://i.tracxn.com/logo/company/oruphones.com_Logo_69e0c37a-5144-41ef-8d11-4e38f526032e.jpg",
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 40),
                    ),
                    child: Text(
                      "Login/SignUp",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 40),
                    ),
                    child: Text("Sell Your Phone"),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text("Blogs"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.support),
            title: Text("Support"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text("Register Store"),
            onTap: () {},
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                height:
                    180, // Set a fixed height for GridView to prevent overflow
                child: GridView.count(
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 5,
                  children: [
                    MenuButton(icon: Icons.shopping_cart, text: "How to Buy"),
                    MenuButton(icon: Icons.attach_money, text: "How to Sell"),
                    MenuButton(icon: Icons.info, text: "About Us"),
                    MenuButton(icon: Icons.question_answer, text: "FAQs"),
                    MenuButton(icon: Icons.privacy_tip, text: "Privacy Policy"),
                    MenuButton(
                        icon: Icons.assignment_return, text: "Refund Policy"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;

  MenuButton({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.black),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          SizedBox(height: 5),
          Text(text,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
