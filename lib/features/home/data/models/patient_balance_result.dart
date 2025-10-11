import 'package:cloud_firestore/cloud_firestore.dart';

class PatientBalanceResult {
  final String id;
  final String userId;
  final String patientName;
  final int age;
  final String gender;
  final double weight;
  final String balanceType; // 'adult', 'child', 'burn'
  final Map<String, dynamic> balanceData;
  final DateTime createdAt;
  final DateTime updatedAt;

  PatientBalanceResult({
    required this.id,
    required this.userId,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.weight,
    required this.balanceType,
    required this.balanceData,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor untuk membuat instance dari Map
  factory PatientBalanceResult.fromMap(Map<String, dynamic> map, String id) {
    return PatientBalanceResult(
      id: id,
      userId: map['userId'] ?? '',
      patientName: map['patientName'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      weight: (map['weight'] ?? 0.0).toDouble(),
      balanceType: map['balanceType'] ?? '',
      balanceData: Map<String, dynamic>.from(map['balanceData'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Factory constructor untuk membuat instance dari DocumentSnapshot
  factory PatientBalanceResult.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PatientBalanceResult.fromMap(data, doc.id);
  }

  // Method untuk mengkonversi ke Map untuk disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'patientName': patientName,
      'age': age,
      'gender': gender,
      'weight': weight,
      'balanceType': balanceType,
      'balanceData': balanceData,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Method untuk membuat copy dengan perubahan tertentu
  PatientBalanceResult copyWith({
    String? id,
    String? userId,
    String? patientName,
    int? age,
    String? gender,
    double? weight,
    String? balanceType,
    Map<String, dynamic>? balanceData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatientBalanceResult(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      patientName: patientName ?? this.patientName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      balanceType: balanceType ?? this.balanceType,
      balanceData: balanceData ?? this.balanceData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'PatientBalanceResult(id: $id, userId: $userId, patientName: $patientName, age: $age, gender: $gender, weight: $weight, balanceType: $balanceType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PatientBalanceResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}