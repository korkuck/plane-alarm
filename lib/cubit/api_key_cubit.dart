import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plane_alarm/services/aero_api_service.dart';
import 'package:plane_alarm/services/api_key_storage.dart';

part 'api_key_state.dart';

class ApiKeyCubit extends Cubit<ApiKeyState> {
  ApiKeyCubit() : super(ApiKeyInitial());

  Future<void> lookForApiKey() async {
    String apiKey;
    try {
      await dotenv.load(fileName: ".env");
      apiKey = dotenv.env['AEROAPI_KEY']?.trim() ?? '';
    } catch (_) {
      apiKey = "";
    }

    if (apiKey.isNotEmpty) {
      await checkApiKeyInEnv(apiKey);
    } else {
      await checkApiKeyInStorage();
    }
  }

  Future<void> checkApiKeyInEnv(String apiKey) async {
    if (apiKey.isEmpty) {
      emit(ApiKeyMissing('API key is missing in .env file.'));
      return;
    }

    final aeroApiService = AeroApiService(apiKey);

    if (!(await aeroApiService.isApiKeyValid())) {
      emit(ApiKeyError('Invalid API key provided.'));
      return;
    }
    emit(ApiKeyReady(apiKey: apiKey, aeroApiService: aeroApiService));
  }

  Future<void> checkApiKeyInStorage() async {
    final storedApiKey = await ApiKeyStorage.readApiKey();
    if (storedApiKey == null || storedApiKey.isEmpty) {
      emit(ApiKeyMissing('API key is missing in secure storage.'));
      return;
    }
    final aeroApiService = AeroApiService(storedApiKey);
    if (!(await aeroApiService.isApiKeyValid())) {
      emit(ApiKeyError('Invalid API key provided.'));
      return;
    }
    emit(
      ApiKeyReady(
        apiKey: storedApiKey,
        aeroApiService: AeroApiService(storedApiKey),
      ),
    );
  }

  Future<void> inputApiKey(String apiKey) async {
    if (apiKey.isEmpty) {
      emit(ApiKeyError('API key cannot be empty.'));
      return;
    }

    final aeroApiService = AeroApiService(apiKey);
    if (!(await aeroApiService.isApiKeyValid())) {
      emit(ApiKeyError('Invalid API key provided.'));
      return;
    }

    await ApiKeyStorage.saveApiKey(apiKey);
    emit(ApiKeyReady(apiKey: apiKey, aeroApiService: aeroApiService));
  }

  void apiKeyError(String message) {
    emit(ApiKeyError(message));
  }
}
