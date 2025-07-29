import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 0)
class Exercise extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final List<String> target;

  @HiveField(4)
  final String equipment;

  @HiveField(5)
  final String? instructions;

  const Exercise({
    required this.id,
    required this.name,
    required this.image,
    required this.target,
    required this.equipment,
    this.instructions,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['gifUrl'] ?? json['image'] ?? '',
      target: List<String>.from(json['target'] ?? []),
      equipment: json['equipment'] ?? '',
      instructions: json['instructions']?.join('\n'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'target': target,
      'equipment': equipment,
      'instructions': instructions,
    };
  }

  @override
  List<Object?> get props => [id, name, image, target, equipment, instructions];
}
