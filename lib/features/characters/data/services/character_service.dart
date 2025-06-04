import '../../../data/network/api_client.dart';
import '../models/character_model.dart';

class CharacterService {
  final ApiClient apiClient;

  CharacterService({required this.apiClient});

  Future<List<CharacterModel>> getCharacters(int page) async {
    final response = await apiClient.get('/character?page=$page');
    final results = response['results'] as List<dynamic>;
    return results.map((json) => CharacterModel.fromJson(json)).toList();
  }
}
