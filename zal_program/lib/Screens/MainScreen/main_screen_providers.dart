import 'dart:io';

import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:zal/Functions/Models/models.dart';
import 'package:zal/Functions/analytics_manager.dart';
import 'package:zal/Functions/programs_runner.dart';
import 'package:zal/Functions/utils.dart';

final executableProvider = StateProvider((ref) async {
  try {
    await ProgramsRunner.runServer();
  } on PathAccessException {
    showSnackbar("couldn't modify server-win.exe, it's being used by another process", ref.read(contextProvider)!);
  }
});

final localSocketObjectProvider = StateProvider<LocalSocketio?>((ref) {
  return LocalSocketio();
});

final contextProvider = StateProvider<BuildContext?>((ref) => null);

final _userStreamProvider = StreamProvider<bool>((ref) => FirebaseAuth.instance.signInState);

final userProvider = FutureProvider<User?>((ref) async {
  final auth = FirebaseAuth.instance;
  ref.watch(_userStreamProvider);
  try {
    final user = await auth.getUser();
    return user;
  } on SignedOutException {
    return null;
  }
});
final consumerTimerProvider = StreamProvider<int>((ref) {
  final stopwatch = Stopwatch()..start();
  return Stream.periodic(const Duration(minutes: 5), (count) {
    AnalyticsManager.sendDataToDatabase("consumer-times");
    return stopwatch.elapsed.inSeconds;
  });
});
