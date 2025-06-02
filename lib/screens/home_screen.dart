import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_mobileapp/models/categories_news_model.dart';
import 'package:news_mobileapp/models/news_channel_headlines_modle.dart';
import 'package:news_mobileapp/screens/categories_screen.dart';
import 'package:news_mobileapp/screens/news_details_screen.dart';
import 'package:news_mobileapp/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {
  bbcNews,
  aryNews,
  aljazeeraNews,
  cryptoNews,
  entertainmentWeekly,
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesScreen()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF136A8A), Color(0xFF267871)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                'assets/images/categories.png',
                height: 22,
                width: 22,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'ZNews',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (FilterList item) {
              switch (item) {
                case FilterList.bbcNews:
                  name = 'bbc-news';
                  break;
                case FilterList.aryNews:
                  name = 'business-insider';
                  break;
                case FilterList.aljazeeraNews:
                  name = 'al-jazeera-english';
                  break;
                case FilterList.cryptoNews:
                  name = 'crypto-coins-news';
                  break;
                case FilterList.entertainmentWeekly:
                  name = 'entertainment-weekly';
                  break;
              }
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder:
                (context) => <PopupMenuEntry<FilterList>>[
                  PopupMenuItem<FilterList>(
                    value: FilterList.bbcNews,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/bbc.png',
                          height: 50,
                          width: 50,
                        ),
                        SizedBox(width: 10),
                        Text('BBC News'),
                      ],
                    ),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.aryNews,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/BB.png',
                          height: 35,
                          width: 35,
                        ),
                        SizedBox(width: 10),
                        Text('Business News'),
                      ],
                    ),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.aljazeeraNews,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/alj.png',
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(width: 10),
                        Text('Al-jazeera News'),
                      ],
                    ),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.cryptoNews,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/crypto.png',
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(width: 10),
                        Text('Crypto News'),
                      ],
                    ),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.entertainmentWeekly,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/entertainment.png',
                          height: 25,
                          width: 25,
                        ),
                        SizedBox(width: 10),
                        Text('Entertainment Weekly'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewChannelHeadlinesApi(name),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(size: 50, color: Colors.blue),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString(),
                      );
                      return InkWell(
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
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                    content:
                                        snapshot
                                            .data!
                                            .articles![index]
                                            .publishedAt
                                            .toString(),
                                    description:
                                        snapshot.data!.articles![index].author
                                            .toString(),
                                    newsData:
                                        snapshot
                                            .data!
                                            .articles![index]
                                            .description
                                            .toString(),
                                    newsTitle:
                                        snapshot.data!.articles![index].content
                                            .toString(),
                                    source:
                                        snapshot.data!.articles![index].source
                                            .toString(),
                                  ),
                            ),
                          );
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height * 0.7,
                                width: width * .9,
                                padding: EdgeInsets.symmetric(
                                  horizontal: height * .02,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        snapshot
                                            .data!
                                            .articles![index]
                                            .urlToImage
                                            .toString(),
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) =>
                                            Container(child: spinKit2),
                                    errorWidget:
                                        (context, url, error) => Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.all(15),
                                    height: height * .22,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: width * 0.7,
                                          child: Text(
                                            snapshot
                                                .data!
                                                .articles![index]
                                                .title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: width * 0.9,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                snapshot
                                                    .data!
                                                    .articles![index]
                                                    .source!
                                                    .name
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('general'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(size: 40, color: Colors.blue),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null) {
                  return const Center(child: Text('No data found'));
                } else {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      final article = snapshot.data!.articles![index];
                      DateTime dateTime = DateTime.parse(article.publishedAt!);
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
                                    (context, url) => const Center(
                                      child: SpinKitCircle(
                                        size: 50,
                                        color: Colors.blue,
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
    );
  }
}

const spinKit2 = SpinKitFadingCircle(color: Colors.amber, size: 50);
