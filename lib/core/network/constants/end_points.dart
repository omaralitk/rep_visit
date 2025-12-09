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

  /// Doctors
  static const _doctorsList = '$_baseUrl/api/doctors';

  static get doctorsList => _doctorsList;

  /// Daily Visits
  static const _dailyVisits = '$_baseUrl/api/daily-visits';

  static get dailyVisits => _dailyVisits;

  /// Start Visit
  static const _startVisit = '$_baseUrl/api/visits/start';

  static get startVisit => _startVisit;

  /// End Visit
  static const _endVisit = '$_baseUrl/api/visits/end';

  static get endVisit => _endVisit;

  /// Update Profile
  static const _updateProfile = '$_baseUrl/api/profile/update';

  static get updateProfile => _updateProfile;

  /// Log Out
  static const _logOut = '$_baseUrl/api/logout';

  static get logOut => _logOut;

  /// Get files
  static const _getFiles = '$_baseUrl/api/files';

  static get getFiles => _getFiles;

  /// Change pass
  static const _changePass = '$_baseUrl/api/profile/change-password';

  static get changePass => _changePass;

  /// Start work
  static const _startWork = '$_baseUrl/api/start-work';

  static get startWork => _startWork;

  /// Start work
  static const _endWork = '$_baseUrl/api/end-work';

  static get endWork => _endWork;
}
