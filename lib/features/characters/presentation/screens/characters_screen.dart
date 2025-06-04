import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/character_card.dart';
import '../../domain/providers/character_provider.dart';

class CharactersScreen extends ConsumerStatefulWidget {
  const CharactersScreen({super.key});

  @override
  CharactersScreenState createState() => CharactersScreenState();
}

class CharactersScreenState extends ConsumerState<CharactersScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final notifier = ref.read(characterProvider.notifier);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        notifier.hasMore &&
        !_isSearching) {
      // Отключаем пагинацию во время поиска
      notifier.loadCharacters();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    ref.read(characterProvider.notifier).filterCharacters(query);
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        ref.read(characterProvider.notifier).resetFilter();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final charactersState = ref.watch(characterProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                ),
                decoration: InputDecoration(
                  hintText: 'Поиск по имени...',
                  hintStyle: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.color?.withOpacity(0.5),
                      ),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(characterProvider.notifier).resetFilter();
                    },
                  ),
                ),
              )
            : const Text('Персонажи'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: charactersState.when(
        data: (characters) => NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            _onScroll();
            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount:
                characters.length +
                (ref.read(characterProvider.notifier).hasMore && !_isSearching
                    ? 1
                    : 0),
            itemBuilder: (context, index) {
              if (index == characters.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final character = characters[index];
              return CharacterCard(character: character);
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}
