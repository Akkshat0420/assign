import 'dart:convert';
//import 'package:assign/bottom_sheeLog.dart';
import 'package:assign/bottom_sheeLog.dart';
import 'package:assign/cusdrawer.dart';
import 'package:assign/splash_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

//import 'package:flutter/widgets.dart';
class FetchProductsPage extends StatefulWidget {
  @override
  _FetchProductsPageState createState() => _FetchProductsPageState();
}

class _FetchProductsPageState extends State<FetchProductsPage> {
  List<dynamic> products = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMoreData = true;
  Set<String> likedProducts = {}; // Store liked product IDs
  SplashService splashService = SplashService();
  List<dynamic> brands = [];
  int _selectedIndex = 0;
  bool _isVisible = true; // Controls visibility of bottom nav
  // ScrollController _scrollController = ScrollController();
  final List<String> imageUrls = [
    'https://res.cloudinary.com/dphtfwnx4/image/upload/v1739341562/fer6_wyh07r.webp',
    'https://res.cloudinary.com/dphtfwnx4/image/upload/v1739341562/fer5_gorh0f.webp',
    'https://res.cloudinary.com/dphtfwnx4/image/upload/v1739341562/fer3_kfcqv6.webp',
    'https://res.cloudinary.com/dphtfwnx4/image/upload/v1739341562/fer4_ybxztz.webp',
    'https://res.cloudinary.com/dphtfwnx4/image/upload/v1739341562/fer2_h4uz51.webp'
  ];
  final List<Map<String, dynamic>> categories = [
    {"title": "Sell Used Phones"},
    {"title": "Buy Used Phones"},
    {"title": "Compare Prices"},
    {"title": "My Profile"},
    {"title": "My Listings"},
    {"title": "Services"},
    {"title": "Register your Store", "isNew": true},
    {"title": "Get the App"},
  ];
  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchBrands();
  }

  Future<void> fetchProducts() async {
    if (isLoading || !hasMoreData) return;

    setState(() => isLoading = true);

    final url = Uri.parse('http://40.90.224.241:5000/filter');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filter": {}, "page": currentPage}),
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey("data") &&
          decodedResponse["data"].containsKey("data")) {
        List<dynamic> newProducts = decodedResponse["data"]["data"];

        setState(() {
          if (newProducts.isNotEmpty) {
            products.addAll(newProducts);
            currentPage++;
          } else {
            hasMoreData = false;
          }
        });
      } else {
        print("Unexpected response format: $decodedResponse");
      }
    } else {
      print("Failed to fetch data: ${response.statusCode}");
    }

    setState(() => isLoading = false);
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

  Future<void> toggleLike(String listingId) async {
    final Uri url = Uri.parse("http://40.90.224.241:5000/isLoggedIn");

    try {
      final response = await http.get(url, headers: {});

      if (response.statusCode == 200) {
        setState(() {
          if (likedProducts.contains(listingId)) {
            likedProducts.remove(listingId);
          } else {
            likedProducts.add(listingId);
          }
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginBottomSheet()),
        );
      }
    } catch (e) {
      print("Error: $e");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginBottomSheet()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
              size: isTablet ? 30 : 24,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🔹 Menu Icon & Logo
            Row(
              children: [
                SizedBox(width: isTablet ? 20 : 10),
                Image.network(
                    'https://i.tracxn.com/logo/company/oruphones.com_Logo_69e0c37a-5144-41ef-8d11-4e38f526032e.jpg',
                    height: isTablet ? 60 : 30),
              ],
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "India",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: isTablet ? 10 : 5),
                Icon(Icons.location_on_outlined,
                    color: Colors.black, size: isTablet ? 28 : 24),
                SizedBox(width: isTablet ? 40 : 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20 : 10,
                      vertical: isTablet ? 12 : 8,
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isTablet ? 18 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.amber),
                        suffixIcon: Icon(Icons.mic, color: Colors.grey),
                        hintText: "Search phones with make, model...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Categories
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.black12),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Text(category["title"] ?? ""),
                                if (category["isNew"] == true)
                                  Container(
                                    margin: EdgeInsets.only(left: 6),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.purpleAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "new",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Center(
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,
                ),
                items: imageUrls.map((url) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
              ),
            ),
            brands.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(children: [
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
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      brand['imagePath'],
                                    ),
                                    onBackgroundImageError:
                                        (error, stackTrace) {
                                      print("Error loading image: $error");
                                    },
                                    child: brand['imagePath'] == null ||
                                            brand['imagePath'].isEmpty
                                        ? Icon(Icons.image_not_supported,
                                            size: 40)
                                        : null,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    brand['make'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ]),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!isLoading &&
                      hasMoreData &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 100) {
                    fetchProducts();
                  }
                  return false;
                },
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(2),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: products.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < products.length) {
                      if ((index + 1) % 7 == 0) {
                        return buildDummyCard();
                      } else {
                        return buildProductCard(products[index]);
                      }
                    } else if (isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return SizedBox(); // Prevent unnecessary widgets
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _isVisible ? 60 : 0,
        child: Wrap(
          children: [
            CurvedNavigationBar(
              backgroundColor: Colors.blueAccent,
              color: Colors.white,
              animationDuration: Duration(milliseconds: 300),
              height: 60,
              index: _selectedIndex,
              items: [
                Icon(Icons.home, size: 30, color: Colors.black),
                Icon(Icons.search, size: 30, color: Colors.black),
                Icon(Icons.favorite, size: 30, color: Colors.black),
                Icon(Icons.person, size: 30, color: Colors.black),
              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }

  Widget buildProductCard(dynamic product) {
    String imageUrl = product["defaultImage"]?["fullImage"] ??
        product["images"]?[0]["fullImage"] ??
        '';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported),
                    )
                  : Icon(Icons.image_not_supported),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product["marketingName"] ?? "Unknown",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("₹${product["listingPrice"] ?? "N/A"}",
                    style: TextStyle(color: Colors.green)),
                Text("${product["deviceStorage"] ?? 'N/A'} Storage"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${product["deviceCondition"] ?? 'N/A'} Condition"),
                    IconButton(
                      icon: Icon(
                          likedProducts.contains(product["listingId"])
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: likedProducts.contains(product["listingId"])
                              ? Colors.red
                              : Colors.grey),
                      onPressed: () => toggleLike(product["listingId"] ?? ""),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDummyCard() {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            'https://res.cloudinary.com/dphtfwnx4/image/upload/v1739294985/DALL2_upxhaj.webp',
            fit: BoxFit.cover,
          ),
        ));
  }
}
