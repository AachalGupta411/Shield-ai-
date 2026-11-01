class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.plan = 'Premium Shield',
    this.authProvider = 'phone',
  });

  final String id;
  final String name;
  final String phone;
  final String? email;
  final String plan;
  final String authProvider;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        if (email != null) 'email': email,
        'plan': plan,
        'authProvider': authProvider,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String?,
        plan: json['plan'] as String? ?? 'Premium Shield',
        authProvider: json['authProvider'] as String? ?? 'phone',
      );
}
