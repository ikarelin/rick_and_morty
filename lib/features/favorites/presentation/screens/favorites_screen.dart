import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/character_card.dart';
import '../../domain/providers/favorite_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              ref.read(favoriteProvider.notifier).sortByDate();
            },
          ),
        ],
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('Нет избранных персонажей'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return CharacterCard(
                  character: favorite.character,
                  key: ValueKey(
                    favorite.character.id,
                  ), // Для уникальности ключей
                );
              },
            ),
    );
  }
}
