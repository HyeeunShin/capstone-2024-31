import 'package:flutter/material.dart';
import 'package:frontend/community/community_screen.dart';
import 'package:frontend/model/config/palette.dart';

class TabCommunityScreen extends StatefulWidget {
  const TabCommunityScreen({super.key});

  @override
  State<TabCommunityScreen> createState() => _TabCommunityScreenState();
}

class _TabCommunityScreenState extends State<TabCommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          title: Container(
              height: 30,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: const Text(
                "인증",
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerHeight: 2,
                      dividerColor: Palette.greySoft,
                      padding: EdgeInsets.only(right: size.width * 0.45),
                      controller: _tabController,
                      splashBorderRadius: BorderRadius.circular(25),
                      overlayColor: MaterialStateProperty.all(Palette.purPle50),
                      tabs: [
                        Tab(
                          child: const Text(
                            '커뮤니티',
                            style: const TextStyle(
                                fontSize: 13, fontFamily: 'Pretendard'),
                          ),

                        ),
                        Tab(
                          child: const Text(
                            'CHAT',
                            style: const TextStyle(
                                fontSize: 13, fontFamily: 'Pretendard'),
                          ),
                        ),
                      ],
                      indicator: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Palette.mainPurple, width: 2.0))),
                      labelColor: Palette.purPle700,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),

                      unselectedLabelStyle:
                          const TextStyle(fontWeight: FontWeight.normal),
                    ))),
          )),
      body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [CommunityScreen(), ChattingList()]),
    );
  }

  Widget CommunityList() {
    return Container();
  }

  Widget ChattingList() {
    return Container();
  }
}
