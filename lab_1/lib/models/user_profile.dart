// R1 & R3: Immutable User Profile model
class UserProfile {
  final String name;
  final String group;

  const UserProfile({required this.name, required this.group});

  const UserProfile.empty() : name = '', group = '';

  UserProfile copyWith({String? name, String? group}) {
    return UserProfile(name: name ?? this.name, group: group ?? this.group);
  }
}
