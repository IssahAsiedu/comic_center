class UserData {
  final String displayName;
  final String avatarUrl;
  final String email;
  final String id;

  UserData({
    required this.displayName,
    required this.avatarUrl,
    required this.email,
    required this.id,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    final avatarUrl = map['avatar_url'];
    final displayName = map['full_name'].toString().split(' ')[0];
    final email = map['email'];
    final id = map['id'];

    return UserData(
      displayName: displayName,
      avatarUrl: avatarUrl,
      email: email,
      id: id,
    );
  }
}
