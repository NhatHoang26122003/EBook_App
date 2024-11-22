import 'dart:convert';

import 'package:ebook_app/detail_audio_page.dart';
import 'package:ebook_app/my_tabs.dart';
import 'package:flutter/material.dart';
import 'package:ebook_app/app_colors.dart' as AppColors;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  late List popularBooks = [];
  late List books = [];
  late ScrollController _scrollController;
  late TabController _tabController;
  Future<List> readData() async {
    String data = await DefaultAssetBundle.of(context).loadString("json/popularBooks.json");
    return List<Map<String, dynamic>>.from(json.decode(data));
  }
  Future<List> bookData() async {
    String data = await DefaultAssetBundle.of(context).loadString("json/books.json");
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    readData();
    bookData().then((data){
      setState(() {
        books = data;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background ,
      child: SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left:20, right:20, top:20),
                  child: const Row (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ImageIcon(AssetImage("img/menu.jpg"), size: 24, color: Colors.black,),
                      Icon(Icons.menu, size: 24, color: Colors.black,),
                      Row (
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 10),
                          Icon(Icons.notifications),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row (
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left:20),
                      child: Text("Popular Books", style: TextStyle(fontSize: 30)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  // margin: const EdgeInsets.only(left:10),
                  height: 180,
                  child: FutureBuilder<List>(
                    future: readData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text("Error loading data"));
                      } else {
                        final popularBooks = snapshot.data!;
                        return PageView.builder(
                          itemCount: popularBooks.length,
                          controller: PageController(viewportFraction: 0.8),
                          itemBuilder: (_, i) {
                            return Container(
                              height: 180,
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(popularBooks[i]["img"]),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                Expanded(child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (BuildContext context, bool isScroll){
                      return [
                        SliverAppBar(
                          pinned: true,
                          bottom: PreferredSize(
                              preferredSize: Size.fromHeight(40),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: TabBar(
                                  indicatorPadding: const EdgeInsets.all(0),
                                  indicatorSize: TabBarIndicatorSize.label,
                                  labelPadding: const EdgeInsets.only(right: 10),
                                  controller: _tabController,
                                  isScrollable: true,
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 7,
                                        offset: Offset(0, 0),
                                      )
                                    ]
                                  ),
                                  tabs: [
                                    AppTabs(color: AppColors.menu1Color, text: "New"),
                                    AppTabs(color: AppColors.menu2Color, text: "Popular"),
                                    AppTabs(color: AppColors.menu3Color, text: "Trending"),
                                  ],
                                ),
                              ),
                          ),
                        )
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height*0.3,
                          child: ListView.builder( itemCount: books.length, itemBuilder: (_, i){
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => DetailAudioPage(booksData: books, index: i,))
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left:20, right:20, top:10, bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.tabVarViewColor,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2,
                                          offset: Offset(0, 0),
                                          color: Colors.grey.withOpacity(0.2),
                                        )
                                      ]
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: AssetImage(books[i]["img"])
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.star, size: 20, color: AppColors.starColor,),
                                                SizedBox(width: 5,),
                                                Text(books[i]["rating"], style:TextStyle(fontSize: 15, color: AppColors.menu2Color)),
                                              ],
                                            ),
                                            Text(books[i]["title"], style: TextStyle(fontSize: 17, fontFamily:"Avenir", fontWeight: FontWeight.bold),),
                                            Text(books[i]["text"], style: TextStyle(fontSize: 13, fontFamily:"Avenir", color: AppColors.subTitleText)),
                                            Container(
                                              width: 60,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: AppColors.loveColor,
                                              ),
                                              child: Text("Love", style: TextStyle(fontSize: 13, fontFamily:"Avenir", color: Colors.white)),
                                              alignment: Alignment.center,
                                            )

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height*0.4,
                          child: ListView.builder( itemCount: books.length, itemBuilder: (_, i){
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => DetailAudioPage(booksData: books, index: i,))
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left:20, right:20, top:10, bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.tabVarViewColor,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2,
                                          offset: Offset(0, 0),
                                          color: Colors.grey.withOpacity(0.2),
                                        )
                                      ]
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: AssetImage(books[i]["img"])
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.star, size: 20, color: AppColors.starColor,),
                                                SizedBox(width: 5,),
                                                Text(books[i]["rating"], style:TextStyle(fontSize: 15, color: AppColors.menu2Color)),
                                              ],
                                            ),
                                            Text(books[i]["title"], style: TextStyle(fontSize: 17, fontFamily:"Avenir", fontWeight: FontWeight.bold),),
                                            Text(books[i]["text"], style: TextStyle(fontSize: 13, fontFamily:"Avenir", color: AppColors.subTitleText)),
                                            Container(
                                              width: 60,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: AppColors.loveColor,
                                              ),
                                              child: Text("Love", style: TextStyle(fontSize: 13, fontFamily:"Avenir", color: Colors.white)),
                                              alignment: Alignment.center,
                                            )

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height*0.4,
                          child: ListView.builder( itemCount: books.length, itemBuilder: (_, i){
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => DetailAudioPage(booksData: books, index: i,))
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left:20, right:20, top:10, bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.tabVarViewColor,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2,
                                          offset: Offset(0, 0),
                                          color: Colors.grey.withOpacity(0.2),
                                        )
                                      ]
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: AssetImage(books[i]["img"])
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.star, size: 20, color: AppColors.starColor,),
                                                SizedBox(width: 5,),
                                                Text(books[i]["rating"], style:TextStyle(fontSize: 15, color: AppColors.menu2Color)),
                                              ],
                                            ),
                                            Text(books[i]["title"], style: TextStyle(fontSize: 17, fontFamily:"Avenir", fontWeight: FontWeight.bold),),
                                            Text(books[i]["text"], style: TextStyle(fontSize: 13, fontFamily:"Avenir", color: AppColors.subTitleText)),
                                            Container(
                                              width: 60,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: AppColors.loveColor,
                                              ),
                                              child: Text("Love", style: TextStyle(fontSize: 13, fontFamily:"Avenir", color: Colors.white)),
                                              alignment: Alignment.center,
                                            )

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ]
                    )
                  )
                )
              ],
            )
          )
      ),
    );
  }
}
