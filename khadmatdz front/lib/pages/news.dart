import 'package:flutter/material.dart';

class News extends StatelessWidget {
  const News({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: RecipeItemMallika1(
          title: 'Title', // Provide the title here
          subtitle: 'Subtitle', // Provide the subtitle here
        ),
      ),
    );
  }
}

class RecipeItemMallika1 extends StatelessWidget {
  String title;
  String subtitle;
  RecipeItemMallika1({required this.title, required this.subtitle, Key? key})
      : super(key: key);
  final dishImage =
      "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/malika%2FRectangle%2013.png?alt=media&token=6a5f056c-417c-48d3-b737-f448e4f13321";
  final orangeColor = const Color(0xffFF8527);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(dishImage)),
      title: Text(title),
      subtitle: Row(
        children: [
          Icon(
            Icons.favorite,
            size: 15,
            color: orangeColor,
          ),
          Text(subtitle),
        ],
      ),
      trailing: const Column(
        children: [
          Icon(Icons.more_vert_outlined),
        ],
      ),
    );
  }
}
