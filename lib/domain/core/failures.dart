import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../auth/email_address.dart';

part 'failures.freezed.dart';

@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.invalidEmail({
    required T failedValue,
  }) = InvalidEmail<T>;
  const factory ValueFailure.shortPassword({
    required T failedValue,
  }) = ShortPassword<T>;
}

void showingTheEmailAddressOrFailure(EmailAddress emailAddress) {
  // Longer to write but we can get the failure instance
  final emailText1 = emailAddress.value.fold(
    (left) => 'Failure happened, more precisely: $left',
    (right) => right,
  );

  // Shorter to write but we cannot get the failure instance
  final emailText2 =
      emailAddress.value.getOrElse(() => 'Some failure happened');
}
