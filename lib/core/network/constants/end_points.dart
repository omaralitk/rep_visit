class EndPoints {
  /// Base url
  static const _baseUrl = 'https://repvisit.com';

  static get baseUrl => _baseUrl;

  ///Onboarding

  static const _onboarding = '$_baseUrl/api/onboarding';

  static get onboarding => _onboarding;

  /// Login
  static const _login = '$_baseUrl/api/login';

  static get login => _login;

  /// Forget Password
  static const _forgetPass = '$_baseUrl/api/forgot-password';

  static get forgetPass => _forgetPass;

  /// Summary
  static const _summaryApi = '$_baseUrl/api/summary';

  static get summaryPi => _summaryApi;

  /// Summary
  static const _reportsApi = '$_baseUrl/api/daily-report';

  static get reportsApi => _reportsApi;
}
