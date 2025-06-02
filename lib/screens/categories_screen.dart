import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_mobileapp/models/categories_news_model.dart';
import 'package:news_mobileapp/screens/news_details_screen.dart';
import 'package:news_mobileapp/view_model/news_view_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String categoryName = 'general';
  List<String> CategoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Business',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black), // Back icon color
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: CategoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      categoryName = CategoriesList[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:
                              categoryName == CategoriesList[index]
                                  ? const LinearGradient(
                                    colors: [
                                      Color(0xFF136A8A),
                                      Color(0xFF267871),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                  : null, // no gradient when not selected
                          color:
                              categoryName == CategoriesList[index]
                                  ? null
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(
                            CategoriesList[index],
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(size: 50, color: Colors.blue),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles == null) {
                    return const Center(child: Text('No data found'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        final article = snapshot.data!.articles![index];
                        DateTime dateTime = DateTime.parse(
                          article.publishedAt!,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: article.urlToImage ?? '',
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder:
                                      (context, url) => Center(
                                        child: ShaderMask(
                                          shaderCallback: (rect) {
                                            return const LinearGradient(
                                              colors: [
                                                Color(0xFF136A8A),
                                                Color(0xFF267871),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(rect);
                                          },
                                          child: const SpinKitCircle(
                                            size: 50,
                                            color:
                                                Colors
                                                    .white, // white because gradient will be applied via shader
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                ),
                              ),

                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => NewsDetailsScreen(
                                                  newImage:
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .urlToImage
                                                          .toString(),
                                                  author:
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .title
                                                          .toString(),
                                                  content:
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .publishedAt
                                                          .toString(),
                                                  description:
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .author
                                                          .toString(),
                                                  newsData:
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .description
                                                          .toString(),
                                                  newsTitle:
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .content
                                                          .toString(),
                                                  source:
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .source
                                                          .toString(),
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        article.title ?? '',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            article.source?.name ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          format.format(dateTime),
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
