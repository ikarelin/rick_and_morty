import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/character_card.dart';
import '../../domain/providers/character_provider.dart';

class CharactersScreen extends ConsumerStatefulWidget {
  const CharactersScreen({super.key});

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends ConsumerState<CharactersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        ref.read(characterProvider.notifier).hasMore) {
      ref.read(characterProvider.notifier).loadCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final charactersState = ref.watch(characterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Персонажи')),
      body: charactersState.when(
        data: (characters) => NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            _onScroll();
            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterCard(
                character: character,
                onFavoriteToggle: () {
                  // Заглушка, доработаем позже
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Добавлено в избранное!')),
                  );
                },
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}
