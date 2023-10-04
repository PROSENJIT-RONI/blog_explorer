import 'package:blog_explorer/views/category_blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helper/blog.dart';
import '../helper/data.dart';
import '../models/article_model.dart';
import '../models/category_model.dart';
import 'article_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];

  List<ArticleModel> articles = [];

  bool _loading = false;

  getNews() async {
    setState(() {
      _loading = true;
    });
    News newsClass = News();
    await newsClass.getBlog();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    categories = getcategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Blog",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "Explorer",
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ///Categories
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return _CategoryTile(
                            imageUrl: categories[index].imageUrl,
                            categoryName: categories[index].categoryName,
                          );
                        },
                      ),
                    ),

                    ///Blogs
                    Container(
                        padding: const EdgeInsets.only(top: 16),
                        child: ListView.builder(
                          itemCount: articles.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return BlogTile(
                              imageUrl: articles[index].urlToImage,
                              title: articles[index].title,
                              description: articles[index].description,
                              url: articles[index].url,
                            );
                          },
                        ))
                  ],
                ),
              ),
            ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String imageUrl, categoryName;

  const _CategoryTile({required this.imageUrl, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryView(
                category: categoryName.toLowerCase(),
              ),
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, description, url;

  const BlogTile(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleView(
                blogUrl: url,
              ),
            ));
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(imageUrl)),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                description,
                style: const TextStyle(color: Colors.black54),
              )
            ],
          )),
    );
  }
}
