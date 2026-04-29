import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/logger/app_logger.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final AppLogger logger;

  AuthRemoteDataSourceImpl({
    required this.auth,
    required this.firestore,
    required this.logger,
  });

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _fetchOrUpdateUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.logError('FirebaseAuthException: ${e.message}', e);
      throw ServerException(e.message ?? 'Authentication failed');
    } catch (e) {
      logger.logError('Exception during signIn', e);
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _fetchOrUpdateUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      logger.logError('FirebaseAuthException: ${e.message}', e);
      throw ServerException(e.message ?? 'Authentication failed');
    } catch (e) {
      logger.logError('Exception during signUp', e);
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      logger.logError('Exception during signOut', e);
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final firebaseUser = auth.currentUser;
      if (firebaseUser != null) {
        return _fetchOrUpdateUser(firebaseUser);
      }
      throw ServerException('No user logged in');
    } catch (e) {
      logger.logError('Exception during getCurrentUser', e);
      throw ServerException();
    }
  }

  Future<UserModel> _fetchOrUpdateUser(firebase_auth.User firebaseUser) async {
    try {
      final userDocRef = firestore.collection('users').doc(firebaseUser.uid);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        final newUserModel = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? 'Learner',
          avatar:
              firebaseUser.photoURL ??
              'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix&backgroundColor=E0E7FF',
          score: 0,
          level: 1,
          progress: 0,
        );

        final newUserMap = newUserModel.toJson();
        newUserMap['createdAt'] = FieldValue.serverTimestamp();
        newUserMap['updatedAt'] = FieldValue.serverTimestamp();

        await userDocRef.set(newUserMap);
        return newUserModel;
      } else {
        return UserModel.fromJson(userDoc.data()!, firebaseUser.uid);
      }
    } catch (e) {
      logger.logError('Error fetching or updating user in Firestore', e);
      throw ServerException('Failed to fetch user data');
    }
  }
}
