// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  User? _firebaseUser;
  String? _userId;
  String? _email;
  String? _name;
  bool _isLoading = false;
  
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthProvider() {
    _initialize();
  }

  User? get firebaseUser => _firebaseUser;
  String? get userId => _userId;
  String? get email => _email;
  String? get name => _name;
  bool get isLoading => _isLoading;

  Future<void> _initialize() async {
    try {
      print('🔄 AuthProvider: Initializing Firebase...');
      
      // Listen to auth state changes
      _auth.authStateChanges().listen((User? user) {
        if (user != null) {
          _firebaseUser = user;
          _email = user.email;
          _userId = user.uid;
          
          // Load additional user data from Firestore
          _loadUserDataFromFirestore(user.uid);
        } else {
          _firebaseUser = null;
          _email = null;
          _name = null;
          _userId = null;
          notifyListeners();
        }
      });
      
      print('✅ AuthProvider: Firebase initialization complete');
    } catch (e) {
      print('❌ AuthProvider: Error during Firebase initialization: $e');
    }
  }

  Future<void> _loadUserDataFromFirestore(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _name = data['name'] as String?;
        print('📥 AuthProvider: Loaded user data from Firestore: $_name');
      } else {
        print('⚠️ AuthProvider: User document not found in Firestore');
      }
      
      notifyListeners();
    } catch (e) {
      print('❌ AuthProvider: Error loading user data from Firestore: $e');
    }
  }

  bool get isAuthenticated {
    return _firebaseUser != null && _email != null;
  }

  // Validasi format email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validasi password (minimal 6 karakter)
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  // LOGIN DENGAN FIREBASE
  Future<Map<String, dynamic>> login(String email, String password) async {
    print('🔑 AuthProvider: Firebase login attempt for: $email');
    
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': ''
    };

    try {
      // Validasi email
      if (!_isValidEmail(email)) {
        result['message'] = 'Format email tidak valid';
        _isLoading = false;
        notifyListeners();
        return result;
      }

      // Validasi password
      if (!_isValidPassword(password)) {
        result['message'] = 'Password minimal 6 karakter';
        _isLoading = false;
        notifyListeners();
        return result;
      }

      // Firebase Authentication Login
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (userCredential.user != null) {
        // Load user data from Firestore
        await _loadUserDataFromFirestore(userCredential.user!.uid);
        
        result['success'] = true;
        result['message'] = 'Login berhasil';
        result['name'] = _name;
        
        print('✅ AuthProvider: Firebase login successful for: $email');
      } else {
        result['message'] = 'Login gagal, user tidak ditemukan';
      }
      
    } on FirebaseAuthException catch (e) {
      print('❌ AuthProvider: Firebase login error: ${e.code} - ${e.message}');
      
      switch (e.code) {
        case 'user-not-found':
          result['message'] = 'Email belum terdaftar';
          break;
        case 'wrong-password':
          result['message'] = 'Password salah';
          break;
        case 'invalid-credential':
          result['message'] = 'Email atau password salah';
          break;
        case 'too-many-requests':
          result['message'] = 'Terlalu banyak percobaan. Coba lagi nanti';
          break;
        default:
          result['message'] = 'Terjadi kesalahan: ${e.message}';
      }
    } catch (e) {
      print('❌ AuthProvider: Login error: $e');
      result['message'] = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  // REGISTER DENGAN FIREBASE
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    print('📝 AuthProvider: Firebase registration attempt for: $email');
    
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': ''
    };

    try {
      // Validasi email
      if (!_isValidEmail(email)) {
        result['message'] = 'Format email tidak valid';
        _isLoading = false;
        notifyListeners();
        return result;
      }

      // Validasi password
      if (!_isValidPassword(password)) {
        result['message'] = 'Password minimal 6 karakter';
        _isLoading = false;
        notifyListeners();
        return result;
      }

      // Validasi nama
      if (name.isEmpty) {
        result['message'] = 'Nama tidak boleh kosong';
        _isLoading = false;
        notifyListeners();
        return result;
      }

      // 1. Create user in Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user == null) {
        result['message'] = 'Registrasi gagal, user tidak dibuat';
        _isLoading = false;
        notifyListeners();
        return result;
      }

      // 2. Update display name in Firebase Auth
      await user.updateDisplayName(name);

      // 3. Save additional user data to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email.trim(),
        'name': name.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 4. Set local state
      _firebaseUser = user;
      _email = email.trim();
      _name = name.trim();
      _userId = user.uid;

      result['success'] = true;
      result['message'] = 'Registrasi berhasil';
      result['name'] = _name;
      
      print('✅ AuthProvider: Firebase registration successful for: $email');
      print('👤 AuthProvider: User ID: $userId');
      
    } on FirebaseAuthException catch (e) {
      print('❌ AuthProvider: Firebase registration error: ${e.code} - ${e.message}');
      
      switch (e.code) {
        case 'email-already-in-use':
          result['message'] = 'Email sudah terdaftar';
          break;
        case 'weak-password':
          result['message'] = 'Password terlalu lemah. Minimal 6 karakter';
          break;
        case 'invalid-email':
          result['message'] = 'Format email tidak valid';
          break;
        case 'operation-not-allowed':
          result['message'] = 'Registrasi dengan email/password tidak diizinkan';
          break;
        default:
          result['message'] = 'Terjadi kesalahan: ${e.message}';
      }
    } catch (e) {
      print('❌ AuthProvider: Registration error: $e');
      result['message'] = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  // LOGOUT DENGAN FIREBASE
  Future<void> logout() async {
    print('🚪 AuthProvider: Firebase logout for user: $_email');
    
    try {
      await _auth.signOut();
      
      _firebaseUser = null;
      _email = null;
      _name = null;
      _userId = null;
      _isLoading = false;
      
      print('✅ AuthProvider: Firebase logout successful');
    } catch (e) {
      print('❌ AuthProvider: Logout error: $e');
    }
    
    notifyListeners();
  }

  // GET USER INFO
  Map<String, dynamic> getUserInfo() {
    final info = {
      'name': _name ?? '',
      'email': _email ?? '',
    };
    
    print('👤 AuthProvider: Getting user info: $info');
    return info;
  }

  // UPDATE PROFILE DENGAN FIREBASE
  Future<Map<String, dynamic>> updateProfile({
    required String name,
  }) async {
    print('✏️ AuthProvider: Updating profile for: $_email');
    
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': ''
    };

    try {
      if (name.isEmpty) {
        result['message'] = 'Nama tidak boleh kosong';
        _isLoading = false;
        notifyListeners();
        return result;
      }

      final user = _auth.currentUser;
      if (user == null) {
        result['message'] = 'User tidak ditemukan';
        _isLoading = false;
        notifyListeners();
        return result;
      }

      // 1. Update display name in Firebase Auth
      await user.updateDisplayName(name);

      // 2. Update name in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'name': name.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 3. Update local state
      _name = name.trim();

      result['success'] = true;
      result['message'] = 'Profil berhasil diperbarui';
      
      print('✅ AuthProvider: Profile updated successfully in Firebase');
      
    } on FirebaseException catch (e) {
      print('❌ AuthProvider: Update profile error: ${e.code} - ${e.message}');
      result['message'] = 'Terjadi kesalahan: ${e.message}';
    } catch (e) {
      print('❌ AuthProvider: Update profile error: $e');
      result['message'] = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  // PASSWORD RESET
  Future<Map<String, dynamic>> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': ''
    };

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      
      result['success'] = true;
      result['message'] = 'Email reset password telah dikirim ke $email';
      
      print('✅ AuthProvider: Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      print('❌ AuthProvider: Password reset error: ${e.code} - ${e.message}');
      
      switch (e.code) {
        case 'user-not-found':
          result['message'] = 'Email tidak terdaftar';
          break;
        case 'invalid-email':
          result['message'] = 'Format email tidak valid';
          break;
        default:
          result['message'] = 'Terjadi kesalahan: ${e.message}';
      }
    } catch (e) {
      print('❌ AuthProvider: Password reset error: $e');
      result['message'] = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  // DELETE ACCOUNT
  Future<Map<String, dynamic>> deleteAccount() async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': ''
    };

    try {
      final user = _auth.currentUser;
      if (user == null) {
        result['message'] = 'User tidak ditemukan';
        _isLoading = false;
        notifyListeners();
        return result;
      }

      // 1. Delete from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // 2. Delete from Firebase Auth
      await user.delete();

      // 3. Clear local state
      _firebaseUser = null;
      _email = null;
      _name = null;
      _userId = null;

      result['success'] = true;
      result['message'] = 'Akun berhasil dihapus';
      
      print('✅ AuthProvider: Account deleted successfully');
      
    } on FirebaseAuthException catch (e) {
      print('❌ AuthProvider: Delete account error: ${e.code} - ${e.message}');
      
      if (e.code == 'requires-recent-login') {
        result['message'] = 'Untuk menghapus akun, login ulang terlebih dahulu';
      } else {
        result['message'] = 'Terjadi kesalahan: ${e.message}';
      }
    } catch (e) {
      print('❌ AuthProvider: Delete account error: $e');
      result['message'] = 'Terjadi kesalahan: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  // Debug method untuk melihat state
  void debugPrintState() {
    print('=== FIREBASE AUTH PROVIDER DEBUG ===');
    print('Firebase User: $_firebaseUser');
    print('Email: $_email');
    print('Name: $_name');
    print('User ID: $_userId');
    print('Is Authenticated: ${isAuthenticated}');
    print('Is Loading: $_isLoading');
    print('Firebase Auth Current User: ${_auth.currentUser?.email}');
    print('===========================');
  }
}