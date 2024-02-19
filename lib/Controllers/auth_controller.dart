import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';

abstract class AuthBase {
  User? get currentUser;

  Stream<User?> authStateChanges();

  // Future<User> signInAnonymously();

  Future<User?> signInWithEmailAndPassword(String email, String password);

  Future<User?> createUserWithEmailAndPassword(String email, String password);

  // Future<User> signInWithGoogle();

  // Future<User> signInWithFacebook();

  Future<void> signOut();
}

class Auth extends GetxController implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  static Auth instance = Get.find();
  @override
  void onInit() {
    if (_firebaseAuth.currentUser != null) {
      loadClaims();
    }
    super.onInit();
  }

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Stream<bool> checkUserVerified() async* {
    bool verified = false;
    while (!verified) {
      await Future.delayed(const Duration(seconds: 5));
      if (currentUser != null) {
        await currentUser!.reload();
        verified = currentUser!.emailVerified;
        if (verified) yield true;
      }
    }
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  Map<String, dynamic>? claims = {};

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    loadClaims();
    return userCredential.user;
  }

  loadClaims() async {
    IdTokenResult result = await currentUser!.getIdTokenResult();
    claims = result.claims;
    print(claims);
    update();
  }

  bool get admin => claims!["role"] == "admin";
  bool get design => claims!["role"] == "design";
  bool get sales => claims!["role"] == "sales";
  bool get store => claims!["role"] == "store";
  bool get purchase => claims!["role"] == "purchase";
  bool get productionLathe => claims!["role"] == "productionLathe";
  bool get productionFab => claims!["role"] == "productionFab";
  bool get delivery => claims!["role"] == "delivery";
  bool get finance => claims!["role"] == "finance";
  bool get productionFabassembly => claims!["role"] == "productionFabassemmbly";
  bool get ProductionAll => claims!["role"] == "productionAll";

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<String> resetPassword({required String email}) async {
    return _firebaseAuth
        .sendPasswordResetEmail(email: email)
        .then((value) => "Success")
        .catchError((error) {
      return error.code.toString();
    });
  }

  signInwithPhoneNumber(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+44 7123 123 456',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? forceResendingToken) {},
      verificationFailed: (FirebaseAuthException error) {},
    );
  }

  @override
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

Auth auth = Auth.instance;
