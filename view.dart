
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../templates/appbar_bg.dart';
import '../../templates/backNdrawerbutton.dart';
import '../../templates/drawer.dart';
import '../../providers/list6.dart';
import '../../templates/global_set.dart';

class MyItemListTest6 extends StatefulWidget {

  static const routeName = "/routeMyItemListTest6";

  const MyItemListTest6({Key? key}) : super(key: key);

  @override
  State<MyItemListTest6> createState() => _MyItemListTest6State();
}

class _MyItemListTest6State extends State<MyItemListTest6> {

  bool _showBackToTopButton = false;

  late ScrollController _scrollControl;

  scrollListener () {
    if (_scrollControl.position.extentAfter < 300) {
      context.read<List6>().loadMore();
    }
    setState(() {
      if (_scrollControl.offset >= 400) {
        _showBackToTopButton = true;
      } else {
        _showBackToTopButton = false;
      }
    });
  }

  @override
  void initState() {
    context.read<List6>().firstLoad();
    _scrollControl = ScrollController()..addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollControl.removeListener(scrollListener);
    super.dispose();
  }

  void _scrollToTop() {
    _scrollControl.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<List6>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          leading: const DrawerButton(),
          flexibleSpace: const AppBarBG(),
          title: const Text("API to Local"),
        ),
        drawer: MainDrawer(),
        body: provider.isFirstLoadRunning
        ? const Center(
          child: CircularProgressIndicator(),
        )
        : RefreshIndicator(
          backgroundColor: const Color.fromARGB(255, 247, 253, 255),
          onRefresh: () async => await provider.firstLoad(),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollControl,
                  itemCount: provider.items.length,
                  itemBuilder: (_, index) {
                    var item = provider.items[index];
                    return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text(item['desc']),
                    ),
                  );
                  },
                ),
              ),
        
              // when the _loadMore function is running
              if (provider.isLoadMoreRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      color: Colors.deepOrangeAccent,
                      strokeWidth: 3.0,
                    ),
                  ),
                ),
        
              // When nothing else to load
              if (provider.hasNextPage == false)
                Container(
                  height: (context.tinggiMedia - context.tinggiAppBar - context.tinggiStatBar) * 0.1,
                  color: Colors.amber,
                  child: const Center(
                    child: Text('You have fetched all of the content'),
                  ),
                ),
            ],
          ),
        ),

        floatingActionButton: _showBackToTopButton == false
        ? null
        : FloatingActionButton(
            onPressed: _scrollToTop,
            backgroundColor: Colors.grey,
            child: const Icon(Icons.keyboard_double_arrow_up, size: 30,),
        ),
      ),
    );
  }



}
