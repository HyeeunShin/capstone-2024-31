import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/config/palette.dart';

class CreateChallenge extends StatefulWidget {
  const CreateChallenge({Key? key});

  @override
  State<CreateChallenge> createState() => _CreateChallengeState();
}

class _CreateChallengeState extends State<CreateChallenge> {
  bool? isPublicSelected; // Changed to nullable bool

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        title: Text(
          '챌린지 생성하기',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
      bottomNavigationBar:  Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            color: Colors.transparent,
              width: double.infinity,
              child: InkWell(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/svgs/create_challenge_btn.svg',
                  // width: double.infinity,
                  // height: 30,

              ))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SvgPicture.asset('assets/svgs/create_challenge_level1.svg'),
          ),
          disclosureButton(
            "public",
            "공개",
            "원하는 사람은 누구든지 참여할 수 있어요.",
            Icons.lock_open_rounded,
          ),
          disclosureButton(
            "private",
            "비공개",
            "암호를 아는 사람만 참여할 수 있어요.",
            Icons.lock_outline_rounded,
          ),
        ],
      ),
    );
  }

  Widget disclosureButton(
    String isOpened,
    String title,
    String memo,
    IconData iconData,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.infinity,
      height: 120,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            isPublicSelected = isOpened == "public";
          });
        },
        icon: Icon(
          iconData,
          size: 50,
          color: isPublicSelected == (isOpened == "public")
              ? Palette.mainPurple
              : Colors.black,
        ),
        label: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$title 챌린지",
                  style: TextStyle(
                    color: isPublicSelected == (isOpened == "public")
                        ? Palette.mainPurple
                        : Colors.black,
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$memo',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Palette.mainPurple,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
