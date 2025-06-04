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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: GestureDetector(
        onTapDown: (_) =>
            (context as Element).markNeedsBuild(), // Для эффекта нажатия
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.identity()..scale(1.0), // Эффект нажатия
          child: Card(
            elevation: 4, // Тень
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Скругленные углы
            ),
            color: Theme.of(
              context,
            ).cardColor.withOpacity(0.95), // Легкая прозрачность
            child: Padding(
              padding: const EdgeInsets.all(12), // Внутренние отступы
              child: Row(
                children: [
                  // Изображение
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      character.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.error,
                        size: 60,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ), // Отступ между изображением и текстом
                  // Текстовые данные
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.color,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${character.status} - ${character.species}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Кнопка избранного
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                    child: IconButton(
                      key: ValueKey<bool>(isFavorite),
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        size: 28,
                      ),
                      onPressed: () {
                        ref
                            .read(favoriteProvider.notifier)
                            .toggleFavorite(character);
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
