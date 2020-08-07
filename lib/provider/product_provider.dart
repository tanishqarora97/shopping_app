import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'product.dart';

const url = 'https://test-project-53c14.firebaseio.com/products.json';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<Product> get favItems {
    return [
      ..._items.where((favProd) => favProd.isFavorite).toList(),
    ];
  }

  // var _showIsFovorites = false;
  List<Product> get items {
    // if (_showIsFovorites == true) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return items.firstWhere((product) => product.id == id);
  }

  // void showFavoritesOnly() {
  //   _showIsFovorites = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showIsFovorites = false;
  //   notifyListeners();
  // }
  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
    } else {
      print('prod index not found');
    }

    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((prodID) => prodID.id == id);
    notifyListeners();
  }

  Future<void> fetchAndSetProduct() async {
    try {
      final response = await http.get(url);
      // print('upcoming data:--${response.body}');
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(
          Product(
            description: prodData['description'],
            id: prodId,
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            title: prodData['title'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _items = loadedProduct;
      notifyListeners();
      print(extractedData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    //   const url = 'https://test-project-53c14.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );

      final newProduct = Product(
        description: product.description,
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      print(newProduct.title);
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
