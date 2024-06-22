import 'package:flutter/material.dart';
import 'news.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy list of news data
    List<NewsData> newsList = [
      NewsData(title: 'News 1', subtitle: 'Subtitle 1'),
      NewsData(title: 'News 2', subtitle: 'Subtitle 2'),
      NewsData(title: 'News 3', subtitle: 'Subtitle 3'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchInput(
              textController: _searchController,
              hintText: 'Search',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: News(
                    title: newsList[index].title,
                    subtitle: newsList[index].subtitle,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NewsData {
  final String title;
  final String subtitle;

  NewsData({required this.title, required this.subtitle});
}

class News extends StatelessWidget {
  final String title;
  final String subtitle;

  const News({required this.title, required this.subtitle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;

  const SearchInput({
    required this.textController,
    required this.hintText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1),
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        onChanged: (value) {
          // Do something with the value
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Color(0xff4338CA)),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}
