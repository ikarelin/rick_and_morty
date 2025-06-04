import 'package:hive/hive.dart';
import '../models/character_model.dart';
import '../services/character_service.dart';
import '../../domain/entities/character.dart';

class CharacterRepository {
  final CharacterService characterService;
  final Box<CharacterModel> cacheBox;

  CharacterRepository({required this.characterService, required this.cacheBox});

  Future<List<Character>> getCharacters(int page) async {
    // Получаем кеш перед началом операции
    final cachedCharacters = cacheBox.values.toList();

    try {
      // Если кеш есть и запрашивается первая страница, возвращаем его
      if (cachedCharacters.isNotEmpty && page == 1) {
        return cachedCharacters.map((model) => model.toEntity()).toList();
      }

      // Загружаем из API
      final characters = await characterService.getCharacters(page);
      // Сохраняем в кеш (только для первой страницы для простоты)
      if (page == 1) {
        await cacheBox.clear();
        await cacheBox.addAll(characters);
      }
      return characters.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Если нет интернета, возвращаем кеш, если он есть
      if (cachedCharacters.isNotEmpty) {
        return cachedCharacters.map((model) => model.toEntity()).toList();
      }
      throw Exception('Failed to load characters: $e');
    }
  }
}
