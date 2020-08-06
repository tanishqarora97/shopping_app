import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routename = '/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('https') ||
          !_imageUrlController.text.startsWith('http'))) {
        return;
      }
      setState(() {});
    }
  }

  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: initValues['title'],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the Title',
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (val) {
                    _editedProduct = new Product(
                      description: _editedProduct.description,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      title: val,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'enter valid value';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  initialValue: initValues['price'],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the price',
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (val) {
                    _editedProduct = new Product(
                      description: _editedProduct.description,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      imageUrl: _editedProduct.imageUrl,
                      price: double.parse(val),
                      title: _editedProduct.title,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'enter valid value';
                    }
                    if (double.tryParse(value) == null) {
                      return 'enter valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'enter value greater than zero';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextFormField(
                  initialValue: initValues['description'],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the Description',
                    labelText: 'Descripition',
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  focusNode: _descriptionFocusNode,
                  onSaved: (val) {
                    _editedProduct = new Product(
                      description: val,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      title: _editedProduct.title,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'enter valid value';
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      margin: EdgeInsets.only(
                        top: 8.0,
                        right: 10.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: (_imageUrlController.text.isEmpty)
                          ? Center(
                              child: Text('Enter a URL'),
                            )
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        // initialValue: initValues['imageUrl'],
                        controller: _imageUrlController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Image URL',
                          labelText: 'Image URL',
                        ),
                        focusNode: _imageUrlFocusNode,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (val) {
                          _editedProduct = new Product(
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: val,
                            price: _editedProduct.price,
                            title: _editedProduct.title,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'enter valid value';
                          }
                          if (!value.startsWith('https') ||
                              !value.startsWith('http')) {
                            return 'Enter a valid url';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
}
