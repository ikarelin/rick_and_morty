import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart';
import '../../data/models/character_model.dart';
import '../../data/repositories/character_repository.dart';
import '../entities/character.dart';
import 'package:hive/hive.dart';

// Провайдер репозитория
final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  // Получаем зависимости через ref
  final apiClient = ref.watch(apiClientProvider);
  final characterService = ref.watch(characterServiceProvider);
  final cacheBox = Hive.box<CharacterModel>('characters');
  return CharacterRepository(
    characterService: characterService,
    cacheBox: cacheBox,
  );
});

// Провайдер для списка персонажей
final characterProvider =
    StateNotifierProvider<CharacterNotifier, AsyncValue<List<Character>>>((
      ref,
    ) {
      return CharacterNotifier(ref.watch(characterRepositoryProvider));
    });

class CharacterNotifier extends StateNotifier<AsyncValue<List<Character>>> {
  final CharacterRepository repository;
  int _page = 1;
  bool _hasMore = true;

  CharacterNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    if (!_hasMore) return;

    state = const AsyncValue.loading();
    try {
      final characters = await repository.getCharacters(_page);
      state = AsyncValue.data(characters);
      _page++;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
