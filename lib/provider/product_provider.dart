import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);
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
  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://test-project-53c14.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
              'description': newProduct.description,
              // 'isFavorite': newProduct.isFavorite,
              //  'id': newProduct.id,
            }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (e) {
        print(e);
        throw e;
      }
    } else {
      print('prod index not found');
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://test-project-53c14.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final value = await http.delete(url);

    if (value.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString = filterByUser?'orderBy="creatorId"&equalTo="$userId"':'';
    final url =
        'https://test-project-53c14.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      if (extractedData == null) {
        return;
      }
      final favUrl =
          'https://test-project-53c14.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoritesResponse = await http.get(favUrl);
      final favData = json.decode(favoritesResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(
          Product(
            description: prodData['description'],
            id: prodId,
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            title: prodData['title'],
            isFavorite: favData == null ? false : favData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://test-project-53c14.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,

            //       'isFavorite': product.isFavorite,
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

      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
