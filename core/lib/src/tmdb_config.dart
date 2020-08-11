class TMDBConfig {
  /// The TMDB API is mostly used for loading actor avatars.
  ///
  /// Having a real API key here is optional; if this doesn't
  /// contain the real API key, the app will still work, but
  /// the actor avatars won't load.
  static const String apiKey = String.fromEnvironment('TMDB_KEY');
}
