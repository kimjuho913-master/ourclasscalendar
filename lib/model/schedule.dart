// lib/model/schedule.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String id;
  final String content;
  final DateTime date;
  final int startTime;
  final int endTime;
  final String colorHexCode;
  final DateTime createdAt;
  final String creator; // 👈 [추가] 작성자 필드

  Schedule({
    required this.id,
    required this.content,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.colorHexCode,
    required this.createdAt,
    required this.creator, // 👈 [추가]
  });

  factory Schedule.fromMap(String id, Map<String, dynamic> map) {
    return Schedule(
      id: id,
      content: map['content'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      startTime: map['startTime'] ?? 0,
      endTime: map['endTime'] ?? 0,
      colorHexCode: map['colorHexCode'] ?? 'd92417',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      creator: map['creator'] ?? '알 수 없음', // 👈 [추가] 데이터가 없을 경우 기본값
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'date': Timestamp.fromDate(date),
      'startTime': startTime,
      'endTime': endTime,
      'colorHexCode': colorHexCode,
      'createdAt': Timestamp.fromDate(createdAt),
      'creator': creator, // 👈 [추가]
    };
  }
}