import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/characters/data/models/character_model.dart';
import 'features/characters/data/repositories/character_repository.dart';
import 'features/characters/data/services/character_service.dart';
import 'features/characters/presentation/screens/characters_screen.dart';
import 'features/data/network/api_client.dart';
import 'features/favorites/presentation/screens/favorites_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';

// Провайдеры для зависимостей
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://rickandmortyapi.com/api');
});

final characterServiceProvider = Provider<CharacterService>((ref) {
  return CharacterService(apiClient: ref.watch(apiClientProvider));
});

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  return CharacterRepository(
    characterService: ref.watch(characterServiceProvider),
    cacheBox: Hive.box<CharacterModel>('characters'),
  );
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CharacterModelAdapter());
  await Hive.openBox<CharacterModel>('characters');
  await Hive.openBox('favorites');
  await Hive.openBox('settings');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _screens = [
    CharactersScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white.withOpacity(0.3)
                  : Colors.black.withOpacity(0.3),
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: BottomAppBar(
                color: Colors.transparent,
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      icon: Icons.list,
                      label: 'Персонажи',
                      index: 0,
                      isSelected: _selectedIndex == 0,
                      onTap: _onItemTapped,
                    ),
                    _buildNavItem(
                      icon: Icons.favorite,
                      label: 'Избранное',
                      index: 1,
                      isSelected: _selectedIndex == 1,
                      onTap: _onItemTapped,
                    ),
                    _buildNavItem(
                      icon: Icons.settings,
                      label: 'Настройки',
                      index: 2,
                      isSelected: _selectedIndex == 2,
                      onTap: _onItemTapped,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required Function(int) onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).iconTheme.color?.withOpacity(0.5),
              size: 24,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(
                        context,
                      ).textTheme.bodySmall?.color?.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
