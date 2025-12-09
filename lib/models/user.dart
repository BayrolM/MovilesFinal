// lib/models/user.dart
class User {
  final int? idUsuario;
  final int? idRol;
  final String? tipoDocumento;
  final String? documento;
  final String? nombres;
  final String? apellidos;
  final String? email;
  final String? telefono;
  final String? direccion;
  final String? ciudad;
  final bool? estado;

  User({
    this.idUsuario,
    this.idRol,
    this.tipoDocumento,
    this.documento,
    this.nombres,
    this.apellidos,
    this.email,
    this.telefono,
    this.direccion,
    this.ciudad,
    this.estado,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUsuario: json['id_usuario'] ?? json['idUsuario'] ?? json['id'],
      idRol: json['id_rol'] ?? json['idRol'],
      tipoDocumento: json['tipo_documento'] ?? json['tipoDocumento'],
      documento: json['documento'],
      nombres: json['nombres'] ?? json['name'],
      apellidos: json['apellidos'] ?? json['apellido'],
      email: json['email'],
      telefono: json['telefono'] ?? json['phone'],
      direccion: json['direccion'] ?? json['address'],
      ciudad: json['ciudad'] ?? json['city'],
      estado: json['estado'] ?? json['state'] ?? json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'id_rol': idRol,
      'tipo_documento': tipoDocumento,
      'documento': documento,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'telefono': telefono,
      'direccion': direccion,
      'ciudad': ciudad,
      'estado': estado,
    };
  }

  /// Propiedad auxiliar para obtener el nombre completo
  String get nombreCompleto => '$nombres $apellidos'.trim();

  /// Propiedad auxiliar para obtener el rol como texto
  String getRolText() {
    switch (idRol) {
      case 1:
        return 'Admin';
      case 2:
        return 'Cliente';
      default:
        return 'Usuario';
    }
  }
}
