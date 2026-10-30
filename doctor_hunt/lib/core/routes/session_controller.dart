import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../enums/user_role.dart';
import '../services/auth_service.dart';
import '../services/local/shared_pref.dart';

/// Coarse authentication state used by the router.
enum SessionStatus { unknown, unauthenticated, authenticated }

/// Single source of truth for "who is signed in and with which role".
///
/// [GoRouter.redirect] has to answer synchronously, so the role is cached in
/// [SharedPref] and refreshed from Firestore in the background whenever the
/// signed-in user changes.
class SessionController extends ChangeNotifier {
  SessionController({required AuthService authService})
    : _authService = authService;

  static const String _roleCacheKey = 'session_role';
  static const String _roleUidCacheKey = 'session_role_uid';

  final AuthService _authService;
  StreamSubscription<User?>? _subscription;

  SessionStatus _status = SessionStatus.unknown;
  UserRole? _role;
  String? _uid;

  SessionStatus get status => _status;
  UserRole? get role => _role;
  String? get uid => _uid;
  bool get isAuthenticated => _status == SessionStatus.authenticated;

  /// Reads the cached session, then starts listening to Firebase Auth.
  ///
  /// Must be awaited before `runApp` so the first redirect already knows the
  /// role. Returns quickly: the Firestore refresh runs in the background.
  Future<void> initialize() async {
    final user = _authService.currentUser;
    if (user == null) {
      _status = SessionStatus.unauthenticated;
      _uid = null;
      _role = null;
      await _clearCachedRole();
    } else {
      _uid = user.uid;
      _status = SessionStatus.authenticated;
      _role = _readCachedRole(user.uid);
      unawaited(_refreshRole(user.uid));
    }
    _subscription ??= _authService.authStateChanges.listen(_onAuthChanged);
    notifyListeners();
  }

  void _onAuthChanged(User? user) {
    if (user == null) {
      _uid = null;
      _role = null;
      _status = SessionStatus.unauthenticated;
      unawaited(_clearCachedRole());
      notifyListeners();
      return;
    }

    final isNewUser = user.uid != _uid;
    _uid = user.uid;
    _status = SessionStatus.authenticated;
    if (isNewUser) {
      _role = _readCachedRole(user.uid);
      unawaited(_refreshRole(user.uid));
    }
    notifyListeners();
  }

  Future<void> _refreshRole(String uid) async {
    final resolved = await _authService.getUserRole(uid);
    // A newer sign-in/sign-out may have happened while the lookup was in flight.
    if (_uid != uid) return;

    if (resolved == null) {
      if (_role != null) {
        _role = null;
        await _clearCachedRole();
        notifyListeners();
      }
      return;
    }

    await SharedPref.cacheData(_roleCacheKey, resolved.name);
    await SharedPref.cacheData(_roleUidCacheKey, uid);
    if (_role != resolved) {
      _role = resolved;
      notifyListeners();
    }
  }

  Future<void> signOut() => _authService.logout();

  /// Applies a role the auth cubits already resolved during login.
  ///
  /// Without this, the first `context.go` after a successful login could run
  /// before the background Firestore lookup finishes and bounce the user back
  /// to role selection.
  Future<void> applyRole(UserRole role) async {
    final user = _authService.currentUser;
    if (user == null) return;

    _uid = user.uid;
    _status = SessionStatus.authenticated;
    final changed = _role != role;
    _role = role;

    if (SharedPref.isInitialized) {
      await SharedPref.cacheData(_roleCacheKey, role.name);
      await SharedPref.cacheData(_roleUidCacheKey, user.uid);
    }
    if (changed) notifyListeners();
  }

  UserRole? _readCachedRole(String uid) {
    if (!SharedPref.isInitialized) return null;
    final cachedUid = SharedPref.pref.getString(_roleUidCacheKey);
    if (cachedUid != uid) return null;

    final cachedRole = SharedPref.pref.getString(_roleCacheKey);
    if (cachedRole == null) return null;
    for (final role in UserRole.values) {
      if (role.name == cachedRole) return role;
    }
    return null;
  }

  Future<void> _clearCachedRole() async {
    if (!SharedPref.isInitialized) return;
    await SharedPref.removeData(_roleCacheKey);
    await SharedPref.removeData(_roleUidCacheKey);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
