import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/auth/sign_in_form/sign_in_form_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
         state.authFailureOrSuccess.fold(
          () {},
          (either) => either.fold(
            (failure) {
              .createError(
                message: failure.map(
                  cancelledByUser: (_) => 'Cancelled',
                  serverError: (_) => 'Server error',
                  emailAlreadyInUse: (_) => 'Email already in use',
                  invalidEmailAndPasswordCombination: (_) =>
                      'Invalid email and password combination',
                ),
              ).show(context);
          },
             (_) {
              // ExtendedNavigator.of(context).replace(Routes.notesOverviewPage);
              // context
              //     .bloc<AuthBloc>()
              //     .add(const AuthEvent.authCheckRequested());
            },
          ),
        );
      },
       
      builder: (context, state) {
        return Form(
            // autovalidateMode: state.showErrorMessage,
            child: ListView(children: [
          const Text(
            '📝',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 130),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
            ),
            autocorrect: false,
            onChanged: (value) => context
                .bloc<SignInFormBloc>()
                .add(SignInFormEvent.emailChanged(value)),
            validator: (value) => state.emailAddress.value.fold(
                (f) => f.map(
                    invalidEmail: (_) => 'Invalid Email',
                    shortPassword: (_) => null),
                (r) => null),
          ),
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              labelText: 'Password',
            ),
            autocorrect: false,
            obscureText: true,
            onChanged: (value) => context
                .bloc<SignInFormBloc>()
                .add(SignInFormEvent.passwordChanged(value)),
            validator: (_) =>
                context.bloc<SignInFormBloc>().state.password.value.fold(
                      (f) => f.maybeMap(
                        shortPassword: (_) => 'Short Password',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.bloc<SignInFormBloc>().add(
                          const SignInFormEvent
                              .signInWithEmailAndPasswordPressed(),
                        );
                  },
                  child: const Text('SIGN IN'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.bloc<SignInFormBloc>().add(
                          const SignInFormEvent
                              .registerWithEmailAndPasswordPressed(),
                        );
                  },
                  child: const Text('REGISTER'),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .bloc<SignInFormBloc>()
                  .add(const SignInFormEvent.signInWithGooglePressed());
            },
            child: const Text(
              'Sign In with Google',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]));
      },
    );
  }
}
