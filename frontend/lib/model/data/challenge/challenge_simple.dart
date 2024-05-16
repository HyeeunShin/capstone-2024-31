import 'dart:convert';

class ChallengeSimple {
  final int id;
  final String challengeName;
  final DateTime startDate;
  final int challengePeriod;
  final String certificationFrequency;
  final int totalParticipants;
  final String imageUrl;
  final String status;
  final bool isPrivate;

  ChallengeSimple({
    required this.id,
    required this.challengeName,
    required this.startDate,
    required this.challengePeriod,
    required this.certificationFrequency,
    required this.totalParticipants,
    required this.imageUrl,
    required this.status,
    required this.isPrivate,
  });

  // JSON에서 객체로 변환
  factory ChallengeSimple.fromJson(Map<String, dynamic> json) {
    return ChallengeSimple(
      id: json['id'],
      challengeName: json['challengeName'],
      startDate: DateTime.parse(json['startDate']),
      challengePeriod: json['challengePeriod'],
      certificationFrequency: json['certificationFrequency'],
      totalParticipants: json['totalParticipants'],
      imageUrl: json['imageUrl'],
      status: json['status'],
      isPrivate: json['isPrivate'],
    );
  }


  // 객체에서 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeName': challengeName,
      'startDate': startDate.toIso8601String(),
      'challengePeriod': challengePeriod,
      'certificationFrequency': certificationFrequency,
      'totalParticipants': totalParticipants,
      'imageUrl': imageUrl,
      'status': status,
      'isPrivate': isPrivate,
    };
  }
}

void main() {
  // JSON 데이터 예시
  String jsonData = '''
  {
    "id": 1,
    "challengeName": "Sample Challenge",
    "startDate": "2024-05-16",
    "challengePeriod": 30,
    "certificationFrequency": "daily",
    "totalParticipants": 100,
    "imageUrl": "http://example.com/image.jpg",
    "status": "ongoing",
    "isPrivate": false
  }
  ''';

  // JSON을 객체로 변환
  Map<String, dynamic> jsonMap = jsonDecode(jsonData);
  ChallengeSimple challenge = ChallengeSimple.fromJson(jsonMap);

  // 객체를 JSON으로 변환
  String jsonString = jsonEncode(challenge.toJson());

  print(jsonString);
}
