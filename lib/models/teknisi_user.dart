class TeknisiUser {
  final String id;
  final String name;
  final String email;
  final List<String> roles;
  final String? phone;
  final String? areaKerja;
  final String? alamat;
  final String? koordinat;
  final DateTime createdAt;

  const TeknisiUser({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    this.phone,
    this.areaKerja,
    this.alamat,
    this.koordinat,
    required this.createdAt,
  });

  factory TeknisiUser.fromJson(Map<String, dynamic> json) {
    // Handle both 'id' and '_id' (MongoDB format)
    final idValue = json['id'] ?? json['_id'];
    return TeknisiUser(
      id: idValue?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((role) => role.toString())
              .toList() ??
          [],
      phone: json['phone'],
      areaKerja: json['area_kerja'],
      alamat: json['alamat'],
      koordinat: json['koordinat'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'phone': phone,
      'area_kerja': areaKerja,
      'alamat': alamat,
      'koordinat': koordinat,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'TeknisiUser(id: $id, name: $name, email: $email, roles: $roles, phone: $phone, areaKerja: $areaKerja)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeknisiUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
