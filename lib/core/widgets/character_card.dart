import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/characters/domain/entities/character.dart';

class CharacterCard extends ConsumerWidget {
  final Character character;
  final VoidCallback onFavoriteToggle;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = false; // Заглушка, доработаем позже

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
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Theme.of(context).primaryColor : null,
          ),
          onPressed: onFavoriteToggle,
        ),
      ),
    );
  }
}
