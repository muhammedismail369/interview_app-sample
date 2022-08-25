import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_ddd/domain/core/value_validators.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:firebase_ddd/domain/auth/email_address.dart';
import 'package:firebase_ddd/domain/auth/i_auth_facade.dart';
import 'package:firebase_ddd/domain/auth/password.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/auth/auth_failure.dart';

part 'sign_in_form_bloc.freezed.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<EmailChanged>((event, emit) async {
      emit(state.copyWith(
        emailAddress: EmailAddress(event.emailStr),
        authFailureOrSuccess: none(),
      ));
    });
    on<PasswordChanged>((event, emit) async {
      emit(state.copyWith(
        password: Password(event.passwordStr),
        authFailureOrSuccess: none(),
      ));
    });
    on<SignInWithGooglePressed>((event, emit) async {
      emit(state.copyWith(
        isSubmitting: true,
        authFailureOrSuccess: none(),
      ));
      final failureOrSuccess = await _authFacade.signInWithGoogle();
      emit(state.copyWith(
        isSubmitting: false,
        authFailureOrSuccess: some(failureOrSuccess),
      ));
    });
    on<RegisterWithEmailAndPasswordPressed>((event, emit) async {
      final isEmailValid = state.emailAddress.isValid();
      final isPasswordValid = state.password.isValid();

      if (isEmailValid && isPasswordValid) {
        emit(state.copyWith(
          isSubmitting: true,
          authFailureOrSuccess: none(),
        ));

        final failureOrSuccess = await _authFacade.registerWithEmailAndPassword(
          emailAddress: state.emailAddress,
          password: state.password,
        );
        emit(state.copyWith(
          isSubmitting: false,
          authFailureOrSuccess: some(failureOrSuccess),
        ));
      }
      emit(state.copyWith(
        isSubmitting: false,
        showErrorMessage: true,
        authFailureOrSuccess: none(),
      ));
    });
    on<SignInWithEmailAndPasswordPressed>((event, emit) async {
      final isEmailValid = state.emailAddress.isValid();
      final isPasswordValid = state.password.isValid();

      if (isEmailValid && isPasswordValid) {
        emit(state.copyWith(
          isSubmitting: true,
          authFailureOrSuccess: none(),
        ));

        final failureOrSuccess = await _authFacade.signInWithEmailAndPassword(
          emailAddress: state.emailAddress,
          password: state.password,
        );
        emit(state.copyWith(
          isSubmitting: false,
          authFailureOrSuccess: some(failureOrSuccess),
        ));
      }
      emit(state.copyWith(
        isSubmitting: false,
        showErrorMessage: true,
        authFailureOrSuccess: none(),
      ));
    });
  }
}
