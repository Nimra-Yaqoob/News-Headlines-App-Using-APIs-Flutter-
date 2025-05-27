import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_mobileapp/models/news_channel_headlines_modle.dart';
import 'package:news_mobileapp/screens/categories_screen.dart';
import 'package:news_mobileapp/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, independent, reuters, cnn, aljazeer }

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
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoriesScreen()));
          },
          icon: Image.asset(
            'assets/images/category_icon.png',
            height: 30,
            width: 30,
          ),
        ),
        title: Center(
          child: Text(
            'News',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (FilterList item) {
              if (FilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (FilterList.aryNews.name == item.name) {
                name = 'ary-news';
              }
              if (FilterList.aljazeer.name == item.name) {
                name = 'al-jazeera-english';
              }
              if (FilterList.aljazeer.name == item.name) {
                name = 'crypto-coins-news';
              }
              if (FilterList.aljazeer.name == item.name) {
                name = 'entertainment-weekly';
              }
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder:
                (context) => <PopupMenuEntry<FilterList>>[
                  PopupMenuItem<FilterList>(
                    value: FilterList.bbcNews,
                    child: Text('BBC News'),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.aryNews,
                    child: Text('Ary News'),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.aljazeer,
                    child: Text('Al-jazeera News'),
                  ),
                   PopupMenuItem<FilterList>(
                    value: FilterList.aljazeer,
                    child: Text('Crypto News'),
                  ),
                   PopupMenuItem<FilterList>(
                    value: FilterList.aljazeer,
                    child: Text('Entertainment weekly'),
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
            child: 
            FutureBuilder<NewsChannelsHeadlinesModel>(
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
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * .04,
                          vertical: height * 0.02,
                        ),
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
                                child:
                                 ClipRRect(
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
                                                MainAxisAlignment.spaceBetween,
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
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(color: Colors.amber, size: 50);
