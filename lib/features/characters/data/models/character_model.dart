import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/character.dart';

part 'character_model.g.dart'; // Для генерации адаптера Hive

@HiveType(typeId: 0)
class CharacterModel extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String status;
  @HiveField(3)
  final String species;
  @HiveField(4)
  final String image;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
  });

  // Парсинг из JSON
  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      image: json['image'] as String,
    );
  }

  // Преобразование в сущность
  Character toEntity() {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      image: image,
    );
  }

  @override
  List<Object?> get props => [id, name, status, species, image];
}
