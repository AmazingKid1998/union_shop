import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // -----------------------------------------------------------------------
  // 1. Mock the NEW Pigeon-based Firebase Core (The source of your error)
  // -----------------------------------------------------------------------
  const pigeonChannelName = 'dev.flutter.pigeon.firebase_core_platform_interface.FirebaseCoreHostApi';
  
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
    pigeonChannelName,
    (ByteData? message) async {
      // The 'initializeCore' method expects a List<Map> response containing app data.
      // We return a dummy initialized app '[DEFAULT]'.
      final reply = [
        {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': 'fakeApiKey',
            'appId': 'fakeAppId',
            'messagingSenderId': 'fakeSenderId',
            'projectId': 'fakeProjectId',
          },
          'pluginConstants': {},
        }
      ];
      // Encode the reply using the standard codec used by Pigeon
      return const StandardMessageCodec().encodeMessage(reply);
    },
  );

  // -----------------------------------------------------------------------
  // 2. Mock the OLD MethodChannel-based Firebase Core (For safety)
  // -----------------------------------------------------------------------
  const MethodChannel channel = MethodChannel('plugins.flutter.io/firebase_core');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    channel,
    (MethodCall methodCall) async {
      if (methodCall.method == 'Firebase#initializeCore') {
        return [
          {
            'name': '[DEFAULT]',
            'options': {
              'apiKey': '123',
              'appId': '123',
              'messagingSenderId': '123',
              'projectId': '123',
            },
            'pluginConstants': {},
          }
        ];
      }
      if (methodCall.method == 'Firebase#initializeApp') {
        return {
          'name': methodCall.arguments['appName'],
          'options': methodCall.arguments['options'],
          'pluginConstants': {},
        };
      }
      return null;
    },
  );

  // -----------------------------------------------------------------------
  // 3. Mock Firebase Auth (Prevents crashes in authStateChanges listener)
  // -----------------------------------------------------------------------
  const MethodChannel authChannel = MethodChannel('plugins.flutter.io/firebase_auth');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    authChannel,
    (MethodCall methodCall) async {
      // Return null for any Auth call to simulate "logged out" or "success"
      return null;
    },
  );
}