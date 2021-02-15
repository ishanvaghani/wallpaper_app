import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final queryChangeNotifierProvider =
    ChangeNotifierProvider<QueryChangeNotifier>((ref) {
  return QueryChangeNotifier();
});

class QueryChangeNotifier extends ChangeNotifier {
  var _searchQuery = '';

  String get searchQuery {
    print(_searchQuery);
    return _searchQuery;
  }

  void updateQuery(String searchQuery) {
    _searchQuery = searchQuery;
    notifyListeners();
  }
}
