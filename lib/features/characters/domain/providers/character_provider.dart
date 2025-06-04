import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../data/repositories/character_repository.dart';
import '../entities/character.dart';

final characterProvider =
    StateNotifierProvider<CharacterNotifier, AsyncValue<List<Character>>>((
      ref,
    ) {
      final repository = ref.watch(characterRepositoryProvider);
      return CharacterNotifier(repository);
    });

class CharacterNotifier extends StateNotifier<AsyncValue<List<Character>>> {
  final CharacterRepository _repository;
  int _page = 1;
  bool _hasMore = true;
  List<Character> _allCharacters = []; // Исходный список для фильтрации

  CharacterNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadCharacters();
  }

  bool get hasMore => _hasMore;

  Future<void> loadCharacters() async {
    if (!_hasMore) return;

    state = const AsyncValue.loading();

    try {
      final characters = await _repository.getCharacters(
        _page,
      ); // Позиционный аргумент
      if (characters.isEmpty) {
        _hasMore = false;
      } else {
        _allCharacters = [
          ..._allCharacters,
          ...characters,
        ]; // Сохраняем исходный список
        state = AsyncValue.data(_allCharacters);
        _page++;
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void filterCharacters(String query) {
    if (query.isEmpty) {
      // Сбрасываем фильтр
      state = AsyncValue.data(_allCharacters);
      return;
    }

    // Фильтруем по имени (игнорируем регистр)
    final filtered = _allCharacters
        .where(
          (character) =>
              character.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    state = AsyncValue.data(filtered);
  }

  void resetFilter() {
    state = AsyncValue.data(_allCharacters);
  }
}
