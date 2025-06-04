import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/characters/domain/entities/character.dart';
import '../../features/favorites/domain/providers/favorite_provider.dart';

class CharacterCard extends ConsumerWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProvider);
    final isFavorite = favorites.any((fc) => fc.character.id == character.id);

    return Card(
      color: Theme.of(context).cardColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            character.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
        ),
        title: Text(
          character.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        subtitle: Text(
          '${character.status} - ${character.species}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: AnimatedSwitcher(
          duration: const Duration(
            milliseconds: 300,
          ), // Плавная анимация 300 мс
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: IconButton(
            key: ValueKey<bool>(
              isFavorite,
            ), // Уникальный ключ для триггера анимации
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Theme.of(context).primaryColor : null,
            ),
            onPressed: () {
              ref.read(favoriteProvider.notifier).toggleFavorite(character);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite
                        ? 'Удалено из избранного!'
                        : 'Добавлено в избранное!',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
