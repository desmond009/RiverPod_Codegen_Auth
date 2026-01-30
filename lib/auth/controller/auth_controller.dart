import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {

  @override
  FutureOr<void> build() {
    // initial state
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider)
          .signUp(email: email, password: password);
    });
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider)
          .signIn(email: email, password: password);
    });
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}