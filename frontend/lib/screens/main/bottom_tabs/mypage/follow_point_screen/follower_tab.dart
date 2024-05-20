import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FollowerTab extends StatelessWidget {
  List<dynamic> followerList;
  FollowerTab({super.key, required this.followerList});


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: followerList.length,
      itemBuilder: (context, index) {
        final follower = followerList[index];
        return FollowerCard(
          imageUrl: follower['image'],
          nickName: follower['name'],
          isFollowing: follower['isFollowing'],
        );
      },
    );
  }
}

class FollowerCard extends StatefulWidget {
  final String imageUrl;
  final String nickName;
  bool isFollowing;

  FollowerCard({
    super.key,
    required this.imageUrl,
    required this.nickName,
    required this.isFollowing,
  });

  @override
  _FollowerCardState createState() => _FollowerCardState();
}

class _FollowerCardState extends State<FollowerCard> {
  final bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        width: double.infinity,
        height: 80,
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(widget.imageUrl),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
              Text(
                widget.nickName,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.isFollowing
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.isFollowing = !widget.isFollowing;
                        });
                      },
                      child: SvgPicture.asset(
                          "assets/svgs/follow_disable_btn.svg"),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.isFollowing = !widget.isFollowing;
                        });
                      },
                      child:
                          SvgPicture.asset("assets/svgs/follow_able_btn.svg"),
                    )
            ]))
          ],
        ));
  }
}
