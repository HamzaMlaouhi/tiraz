import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiraz/core/di/injection_container.dart';

import 'fake_api.dart';
import 'fake_network_images.dart';

/// Boots the app's dependencies the way `main()` does, but against
/// [FakeApi] instead of a real server, with in-memory storage and fake
/// network images. [signedIn] seeds a saved session, as if the user had
/// logged in before — needed for anything behind the backend's JWT guard
/// (cart badge, seller mode).
Future<FakeApi> setUpTestApp({bool signedIn = true}) async {
  HttpOverrides.global = FakeNetworkImageHttpOverrides();
  SharedPreferences.setMockInitialValues({});
  FlutterSecureStorage.setMockInitialValues(signedIn
      ? {
          'auth_token': 'test-token',
          'auth_user_id': 'test-user',
          'auth_phone': '+971501234567',
          'auth_emirate': 'ABU_DHABI',
        }
      : {});

  await initDependencies();
  final api = FakeApi();
  sl<Dio>().httpClientAdapter = api;
  return api;
}

Future<void> tearDownTestApp() async {
  HttpOverrides.global = null;
  await sl.reset();
}
