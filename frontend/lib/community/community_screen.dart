import 'package:flutter/material.dart';
import 'package:frontend/community/widget/post_card.dart';
import 'package:frontend/main/main_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';
import 'package:frontend/model/data/post.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key, this.isFromCreatePostingScreen = false});

  final bool isFromCreatePostingScreen;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  final logger = Logger();

  final int _selectedIndex = 0; // 탭 인덱스
  int _sortIndex = 0; // 정렬 방식 인덱스

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _selectedButtonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.0),
      ),
      foregroundColor: Palette.white,
      backgroundColor: Palette.purPle400,
      disabledBackgroundColor: Palette.greySoft,
      disabledForegroundColor: Colors.white,
      minimumSize: const Size(60, 36));

  final _unselectedButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      side: BorderSide.none,
      borderRadius: BorderRadius.circular(20.0),
    ),
    foregroundColor: Palette.grey200,
    backgroundColor: Palette.greySoft,
    shadowColor: Colors.transparent,
    minimumSize: const Size(60, 36),

    // padding: const EdgeInsets.symmetric(vertical: 12.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              widget.isFromCreatePostingScreen
                  ? Get.to(() => MainScreen())
                  : Get.back();
            },
          ),
          title: const Text(
            "인증 커뮤니티",
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
        body: Column(
          children: [
            _buildSortButtons(),
            Expanded(
                child: ListView.builder(
                    itemCount: 30,
                    itemBuilder: (BuildContext context, int index) {
                      return PostCard(
                        number: index,
                      );
                    }))
          ],
        ));
  }

  Widget _buildSortButtons() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        color: Palette.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _sortIndex = 0;
                });
              },
              style: _sortIndex == 0
                  ? _selectedButtonStyle
                  : _unselectedButtonStyle,
              child: const Text(
                '최신순',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                    fontSize: 12),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _sortIndex = 1;
                });
              },
              style: _sortIndex == 1
                  ? _selectedButtonStyle
                  : _unselectedButtonStyle,
              child: const Text('인기순',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pretendard',
                      fontSize: 12)),
            ),
          ],
        ));
  }
}
