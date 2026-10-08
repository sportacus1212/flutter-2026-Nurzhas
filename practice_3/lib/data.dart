class ProfileFact {
  final String label;
  final String value;

  const ProfileFact({
    required this.label,
    required this.value,
  });
}

const String myName = 'Nurzhas';
const String myUniversity = 'KBTU';

const List<ProfileFact> facts = [
  ProfileFact(label: 'Major', value: 'Information Systems'),
  ProfileFact(label: 'Year', value: '4th Year'),
  ProfileFact(label: 'City', value: 'Almaty'),
  ProfileFact(label: 'Hobby', value: 'Speedcubing'),
];