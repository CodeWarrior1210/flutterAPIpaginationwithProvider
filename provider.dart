
import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:http/http.dart' as webserv;
import '../../templates/global_set.dart' as globalvars;

class List6 with ChangeNotifier {

  int page = 1; // for first page load at url

  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;

  List _items = []; 

  List<dynamic> get items {
    return _items.toList();
  }

  Future<List> callAPIItems() async {
    final response = await webserv.get(Uri.parse('${globalvars.dLocalUrl}/produksPg?page=$page'));
    final extractedData = json.decode(response.body);
    return extractedData['resB']['data'];
  }

  Future firstLoad() async {
    page = 1; // must return to 1
    isFirstLoadRunning = true;
    try {
      _items = await callAPIItems();
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
    hasNextPage = true;
    isFirstLoadRunning = false;
    notifyListeners();
  }

  Future loadMore() async {
    if (hasNextPage == true && isFirstLoadRunning == false && isLoadMoreRunning == false) {
      isLoadMoreRunning = true;
      page = page + 1;
      try {
        final List fetchedPosts = await callAPIItems();
        if (fetchedPosts.isNotEmpty) {
            _items.addAll(fetchedPosts);
        } else {
          hasNextPage = false;
        }
      } catch (err) {
        if (kDebugMode) {
          print(err.toString());
        }
      }
      isLoadMoreRunning = false;
    }
    notifyListeners();
  }


}