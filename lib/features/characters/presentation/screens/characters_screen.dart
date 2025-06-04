import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/character_provider.dart';

class CharactersScreen extends ConsumerWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersState = ref.watch(characterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Персонажи')),
      body: charactersState.when(
        data: (characters) => ListView.builder(
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final character = characters[index];
            return ListTile(
              leading: Image.network(character.image, width: 50, height: 50),
              title: Text(character.name),
              subtitle: Text('${character.status} - ${character.species}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}
