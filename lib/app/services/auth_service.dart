import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/user_model.dart';
import '../routes/app_pages.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _storage = GetStorage();

  Rx<User?> currentUser = Rx<User?>(null);
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  Future<AuthService> init() async {
    await GetStorage.init();
    currentUser.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        userModel.value = null;
        _storage.remove('userRole');
      }
    });
    return this;
  }

  Future<void> _loadUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        userModel.value = UserModel.fromFirestore(doc);
        _storage.write('userRole', userModel.value?.role.toString().split('.').last);
        _redirectBasedOnRole();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void _redirectBasedOnRole() {
    if (userModel.value == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    switch (userModel.value?.role) {
      case UserRole.admin:
        Get.offAllNamed(Routes.ADMIN_DASHBOARD);
        break;
      case UserRole.recruiter:
      case UserRole.candidate:
        Get.offAllNamed(Routes.DASHBOARD);
        break;
      default:
        Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In process...');
      
      // Check if Google Sign-In is available
      final isAvailable = await _googleSignIn.isSignedIn();
      print('Google Sign-In is available: $isAvailable');
      
      // Sign out first to ensure a clean state
      await _googleSignIn.signOut();
      print('Signed out from previous Google session');
      
      // Attempt to sign in
      print('Attempting to sign in with Google...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('Google Sign-In was cancelled by the user');
        return null;
      }
      
      print('Google Sign-In successful, getting authentication...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Check if the tokens are null
      if (googleAuth.accessToken == null) {
        print('Google access token is null');
        return null;
      }
      
      if (googleAuth.idToken == null) {
        print('Google ID token is null');
        return null;
      }
      
      print('Creating credential with tokens...');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Signing in with Firebase...');
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        print('Firebase sign-in successful, user: ${userCredential.user!.uid}');
        await _createOrUpdateUser(userCredential.user!);
      } else {
        print('Firebase sign-in returned null user');
      }

      return userCredential;
    } catch (e, stackTrace) {
      print('Error signing in with Google: $e');
      print('Stack trace: $stackTrace');
      // Re-throw the error to be handled by the controller
      throw e;
    }
  }

  Future<void> _createOrUpdateUser(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // Create new user
      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        role: UserRole.candidate,
        profileImage: user.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await userDoc.set(newUser.toMap());
      userModel.value = newUser;
      _storage.write('userRole', newUser.role.toString().split('.').last);
    } else {
      // Update existing user
      final existingUser = UserModel.fromFirestore(docSnapshot);
      final updatedUser = existingUser.copyWith(
        email: user.email,
        name: user.displayName,
        profileImage: user.photoURL,
      );

      await userDoc.update(updatedUser.toMap());
      userModel.value = updatedUser;
      _storage.write('userRole', updatedUser.role.toString().split('.').last);
    }
    _redirectBasedOnRole();
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      userModel.value = null;
      _storage.remove('userRole');
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> updateUserRole(String userId, UserRole newRole) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (userModel.value?.uid == userId) {
        userModel.value = userModel.value?.copyWith(
          role: newRole,
        );
        _storage.write('userRole', newRole.toString().split('.').last);
        _redirectBasedOnRole();
      }
    } catch (e) {
      print('Error updating user role: $e');
    }
  }

  bool get isAdmin => userModel.value?.role == UserRole.admin;
  bool get isRecruiter => userModel.value?.role == UserRole.recruiter;
  bool get isCandidate => userModel.value?.role == UserRole.candidate;

  // Test method to verify Google Sign-In configuration
  Future<bool> testGoogleSignInConfig() async {
    try {
      print('Testing Google Sign-In configuration...');
      
      // Check if Google Sign-In is available
      final isAvailable = await _googleSignIn.isSignedIn();
      print('Google Sign-In is available: $isAvailable');
      
      // Get the current user
      final currentUser = await _googleSignIn.signInSilently();
      print('Current Google user: ${currentUser?.email ?? 'None'}');
      
      // Check if we can get the scopes
      final scopes = await _googleSignIn.scopes;
      print('Google Sign-In scopes: $scopes');
      
      return true;
    } catch (e, stackTrace) {
      print('Error testing Google Sign-In configuration: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }
} 