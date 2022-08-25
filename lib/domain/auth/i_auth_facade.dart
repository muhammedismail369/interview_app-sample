import 'dart:ffi';
import 'dart:html';

import 'package:dartz/dartz.dart';
import 'package:firebase_ddd/domain/auth/auth_failure.dart';
import 'package:firebase_ddd/domain/auth/email_address.dart';
import 'package:firebase_ddd/domain/auth/user.dart';

import 'password.dart';

abstract class IAuthFacade {
  Future<Option<User>> getSignedInUse();
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
  Future<void> signOut();
}
