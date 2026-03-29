class AppConstants {
  // API base URLs
  static const apiBaseUrlIosSim = 'http://127.0.0.1:8080';
  static const apiBaseUrlAndroidEmu = 'http://10.0.2.2:8080';
  static const apiBaseUrlProd = 'https://api.playrapid.com';

  // WebSocket
  static const wsBaseUrlLocal = 'ws://127.0.0.1:8080/ws';
  static const wsBaseUrlProd = 'wss://api.playrapid.com/ws';

  // Game settings
  static const roundsPerGame = 10;
  static const questionTimeoutMs = 15000;
  static const countdownSeconds = 3;
  static const revealAutoAdvanceMs = 4000;
  static const suspensePauseMs = 800;
  static const challengeTimeoutSeconds = 60;

  // Animation durations
  static const questionEntranceMs = 300;
  static const optionPressMs = 100;
  static const scoreCountUpMs = 1500;
  static const countdownBeatMs = 1000;
  static const screenTransitionMs = 350;
}
