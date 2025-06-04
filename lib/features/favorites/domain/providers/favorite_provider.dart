import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty/features/characters/domain/entities/character.dart';
import 'package:rick_and_morty/features/characters/data/models/character_model.dart';

part 'favorite_provider.g.dart'; // Перемещаем директиву в начало

// Модель для хранения персонажа с датой добавления
@HiveType(typeId: 1)
class FavoriteCharacter {
  @HiveField(0)
  final CharacterModel characterModel;
  @HiveField(1)
  final DateTime addedAt;

  FavoriteCharacter(this.characterModel, this.addedAt);

  Character get character => characterModel.toEntity();
}

// Провайдер для списка избранных персонажей
final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<FavoriteCharacter>>((ref) {
      return FavoriteNotifier();
    });

class FavoriteNotifier extends StateNotifier<List<FavoriteCharacter>> {
  static const String _boxName = 'favorites';
  late Box<FavoriteCharacter> _box;

  FavoriteNotifier() : super([]) {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    _box = await Hive.openBox<FavoriteCharacter>(_boxName);
    // Загружаем данные из Hive
    state = _box.values.toList();
  }

  void toggleFavorite(Character character) {
    final existingIndex = state.indexWhere(
      (fc) => fc.character.id == character.id,
    );
    if (existingIndex != -1) {
      // Удаляем из избранного
      state = List.from(state)..removeAt(existingIndex);
      _box.deleteAt(existingIndex);
    } else {
      // Добавляем в избранное
      final characterModel = CharacterModel(
        id: character.id,
        name: character.name,
        status: character.status,
        species: character.species,
        image: character.image,
      );
      final newFavorite = FavoriteCharacter(characterModel, DateTime.now());
      state = [...state, newFavorite];
      _box.add(newFavorite);
    }
  }

  // Сортировка по дате добавления (по убыванию)
  void sortByDate() {
    state = [...state]..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }
}
