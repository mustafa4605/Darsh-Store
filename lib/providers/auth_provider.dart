import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/services/api_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final String? token;
  final double? balance;

  AuthState({
    this.status = AuthStatus.initial,
    this.token,
    this.balance,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    double? balance,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      balance: balance ?? this.balance,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthNotifier(this._apiService) : super(AuthState()) {
    _init();
  }

  Future<void> _init() async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != null) {
      state = AuthState(status: AuthStatus.authenticated, token: token);
      await fetchBalance(); // Fetch balance on initial load if authenticated
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final token = await _apiService.login(username, password);
      state = state.copyWith(status: AuthStatus.authenticated, token: token);
      await fetchBalance();
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> signUp(String username, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _apiService.signUp(username, password);
      await login(username, password);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> googleSignIn() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null) {
          final token = await _apiService.googleSignIn(googleAuth.idToken!);
          state = state.copyWith(status: AuthStatus.authenticated, token: token);
          await fetchBalance();
        }
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> fetchBalance() async {
    try {
      final balance = await _apiService.fetchBalance();
      state = state.copyWith(balance: balance);
    } catch (e) {
      print('Failed to fetch balance: $e');
      // Optionally handle the error, e.g., show a message to the user
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
    await _googleSignIn.signOut();
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

// Provider for the ApiService
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Provider for the AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthNotifier(apiService);
});
