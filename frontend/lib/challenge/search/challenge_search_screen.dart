import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:frontend/env.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_challenge_item_card.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:frontend/model/data/challenge/challenge_category.dart';
import 'package:frontend/model/data/challenge/challenge_filter.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeSearchScreen extends StatefulWidget {
  const ChallengeSearchScreen({super.key});

  @override
  State<ChallengeSearchScreen> createState() => _ChallengeSearchScreenState();
}

class _ChallengeSearchScreenState extends State<ChallengeSearchScreen> {
  final logger = Logger();

  List<String> categoryList =
      ['전체'] + ChallengeCategory.values.map((e) => e.name).toList();
  String searchValue = '';
  int selectedIndex = 0;
  bool _isPrivate = false;
  List<ChallengeSimple> challengeList = [];

  int currentCursor = 0;
  final int pageSize = 10;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  void _getChallengeList() async {
    if (!hasMoreData) return;

    Dio dio = Dio();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString('access_token')}';

    try {
      final filter = ChallengeFilter(
              name: searchValue,
              isPrivate: _isPrivate,
              category: selectedIndex == 0
                  ? null
                  : ChallengeCategory.values[selectedIndex - 1])
          .toJson();
      logger.d("challenge filter: $filter");

      final response = await dio.get('${Env.serverUrl}/challenges/list',
          data: filter,
          queryParameters: {
            'cursor': currentCursor,
            'size': pageSize,
          });

      if (response.statusCode == 200) {
        logger.d(response.data);
        List<ChallengeSimple> newData = (response.data as List)
            .map((c) => ChallengeSimple.fromJson(c))
            .toList();

        setState(() {
          if (newData.isNotEmpty) {
            challengeList.addAll(newData);
            currentCursor = challengeList.last.id;
          } else {
            hasMoreData = false;
          }
        });
      } else {
        throw Exception("Failed to load more data");
      }
    } catch (e) {
      logger.d(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getChallengeList(); // 초기 데이터 로드
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getChallengeList(); // 스크롤 끝에 도달할 때 추가 데이터 로드
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 스크롤 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EasySearchBar(
          backgroundColor: Palette.mainPurple,
          foregroundColor: Palette.white,
          searchTextStyle: const TextStyle(
            color: Palette.mainPurple,
            fontFamily: "Pretendard",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          title: const Text(
            "챌린지 모아보기",
            style: TextStyle(
              fontFamily: "Pretendard",
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          onSearch: (value) => setState(() => searchValue = value),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  selectCategory(),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    const Text(
                      "비공개 챌린지만",
                      style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Palette.grey300,
                      ),
                    ),
                    const SizedBox(width: 5),
                    CupertinoSwitch(
                      value: _isPrivate,
                      thumbColor: Palette.white,
                      trackColor: Palette.greySoft,
                      activeColor: Palette.purPle300,
                      onChanged: (bool? value) {
                        setState(() {
                          _isPrivate = value ?? false;
                          hasMoreData = true;
                          currentCursor = 0;
                          challengeList.clear();
                          _getChallengeList();
                        });
                      },
                    ),
                  ]),
                  const SizedBox(height: 5),
                  Expanded(
                      child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.4,
                    ),
                    itemCount: challengeList.length,
                    itemBuilder: (context, index) {
                      return ChallengeItemCard(data: challengeList[index]);
                    },
                  ))
                ])));
  }

  Widget selectCategory() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  categoryList.length,
                  (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (selectedIndex == index) {
                              selectedIndex = 0; // Deselect if already selected
                            } else {
                              selectedIndex = index; // Select otherwise
                            }
                            hasMoreData = true;
                            currentCursor = 0;
                            challengeList.clear();
                            _getChallengeList();
                          });
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry?>(
                            const EdgeInsets.symmetric(horizontal: 15),
                          ),
                          maximumSize: MaterialStateProperty.all<Size>(
                              const Size(80, 35)),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(10, 35)),
                          // Adjust the button's size
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          backgroundColor: selectedIndex == index
                              ? MaterialStateProperty.all<Color>(
                                  Palette.purPle400)
                              : null,
                        ),
                        child: Text(categoryList[index],
                            style: TextStyle(
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Palette.grey200,
                                fontSize: 11,
                                fontWeight: selectedIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.w500)),
                      ))),
            )));
  }
}
