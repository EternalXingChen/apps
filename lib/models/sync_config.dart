class SyncConfig {
  final bool autoSync;
  final String syncInterval;
  final String provider;
  final String? serverUrl;
  final String? username;
  final String? password;

  SyncConfig({
    this.autoSync = false,
    this.syncInterval = 'daily',
    this.provider = 'local',
    this.serverUrl,
    this.username,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'autoSync': autoSync,
      'syncInterval': syncInterval,
      'provider': provider,
      'serverUrl': serverUrl,
      'username': username,
      'password': password,
    };
  }

  factory SyncConfig.fromJson(Map<String, dynamic> json) {
    return SyncConfig(
      autoSync: json['autoSync'] ?? false,
      syncInterval: json['syncInterval'] ?? 'daily',
      provider: json['provider'] ?? 'local',
      serverUrl: json['serverUrl'],
      username: json['username'],
      password: json['password'],
    );
  }
}
