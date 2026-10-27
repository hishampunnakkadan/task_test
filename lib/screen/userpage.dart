import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/product_api.dart';
import 'package:flutter_application_1/models/productmodel.dart';

class Userpage extends StatefulWidget {
  @override
  State<Userpage> createState() => _UserPageState();
}

class _UserPageState extends State<Userpage> {
  late Future<List<Product>> futureProducts;
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    futureProducts = getProducts();
  }

  void retry() {
    setState(() {
      futureProducts = getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Failed to load products'),
                        ElevatedButton(onPressed: retry, child: Text('Retry')),
                      ],
                    ),
                  );
                }

                List<Product> products = snapshot.data!;

                List<Product> filteredProducts = products.where((product) {
                  return product.title.toLowerCase().contains(searchText);
                }).toList();

                if (filteredProducts.isEmpty) {
                  return Center(child: Text('No products found'));
                }

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    Product product = filteredProducts[index];

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Image.network(
                              product.image,
                              height: 90,
                              width: 80,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                );
                              },
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
