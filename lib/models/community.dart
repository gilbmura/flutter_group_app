import 'campus.dart';

class Community {
  final String id;
  final String name;
  final int members;
  final Campus campus;
  final String description;
  final bool joined;

  const Community({
    required this.id,
    required this.name,
    required this.members,
    required this.campus,
    required this.description,
    this.joined = false,
  });

  Community copyWith({bool? joined, int? members}) => Community(
        id: id,
        name: name,
        members: members ?? this.members,
        campus: campus,
        description: description,
        joined: joined ?? this.joined,
      );
}
