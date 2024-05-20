import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:get/get.dart';
import 'package:frontend/model/data/user.dart';
import 'package:frontend/model/data/challenge/challenge_category.dart';

class UserController extends GetxController {
  final Rx<User> _user = User(
    id: 0,
    email: '',
    name: '',
    avatar: '',
    point: 0,
    categories: [],
    following: [],
    followers: [],
  ).obs;

  final _myChallenges = <ChallengeSimple>[].obs;

  User get user => _user.value;

  List<ChallengeSimple> get myChallenges => _myChallenges;

  void saveUser(User user) {
    _user.value = user;
  }

  void addMyChallenge(ChallengeSimple challenge) {
    _myChallenges.add(challenge);
  }

  void updateMyChallenges(List<ChallengeSimple> challenges) {
    _myChallenges.assignAll(challenges);
  }

  void updateCategories(List<ChallengeCategory> categories) {
    _user.value.categories.assignAll(categories);
  }
}
