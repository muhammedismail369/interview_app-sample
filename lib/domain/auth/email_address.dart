import 'package:dartz/dartz.dart';
import 'package:firebase_ddd/domain/core/value_objects.dart';
import 'package:flutter/foundation.dart';

import '../core/failures.dart';
import '../core/value_validators.dart';

class EmailAddress extends ValueObject<String> {
  final Either<ValueFailure<String>, String> value;

  factory EmailAddress(String input) {
    assert(input != null);
    return EmailAddress._(
      validateEmailAddress(input),
    );
  }

  const EmailAddress._(this.value);
}
