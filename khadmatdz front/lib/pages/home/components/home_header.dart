import 'package:flutter/material.dart';
import 'icon_btn_with_counter.dart';
import 'newsfeed.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: SearchField()),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Add your filtering functionality here
            },
          ),
          const SizedBox(width: 8),


          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsFeedPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CartScreen {
}
