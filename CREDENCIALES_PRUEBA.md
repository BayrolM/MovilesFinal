# Credenciales de Prueba - API Backend

## 🔐 Usuarios de Prueba Disponibles

Según la documentación de la API y el LoginScreen del proyecto, estos son los usuarios de prueba:

### Admin
```
Email:    admin@test.com
Password: 123456
Rol:      1 (Admin)
```

### Cliente
```
Email:    cliente@test.com
Password: 123456
Rol:      2 (Cliente)
```

---

## 🧪 Cómo Probar la Integración

### 1. Iniciar la App
```bash
flutter run
```

### 2. En LoginScreen
- Ingresar credenciales de prueba
- Presionar "INICIAR SESIÓN"
- La app debería:
  - Obtener el token de `/api/auth/login`
  - Guardar el token en almacenamiento seguro
  - Llamar a `/api/users/profile` con el token
  - Obtener datos del usuario
  - Redirigir a la pantalla correspondiente (Admin o Client)

### 3. Verificar el Rol
- **Si idRol == 1:** Ir a `AdminMainScreen`
- **Si idRol == 2:** Ir a `ClientMainScreen`

---

## 🔗 Endpoints Usados en Login

1. **POST** `https://back02-y3wc.vercel.app/api/auth/login`
   - Request: `{ "email": "admin@test.com", "password": "123456" }`
   - Response: `{ "token": "eyJhbGciOi..." }`

2. **GET** `https://back02-y3wc.vercel.app/api/users/profile`
   - Headers: `Authorization: Bearer <token>`
   - Response: Datos completos del usuario

---

## 📋 Crear un Nuevo Usuario de Prueba

### Usando Postman o curl:

```bash
curl -X POST https://back02-y3wc.vercel.app/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "id_rol": 2,
    "tipo_documento": "CC",
    "documento": "9876543210",
    "nombres": "Carlos",
    "apellidos": "García",
    "email": "carlos@example.com",
    "telefono": "3209876543",
    "direccion": "Carrera 45 #12-34",
    "ciudad": "Medellín",
    "password": "password123"
  }'
```

### Desde la App:
1. Si implementas RegisterScreen, usará `AuthProvider.register()`
2. Completa todos los campos requeridos
3. El registro es automáticamente seguido de login

---

## ⚠️ Notas Importantes

1. **Token válido por 7 días**
2. **Password mínimo 6 caracteres** (según validación en LoginScreen)
3. **Email único** - No puede registrarse dos cuentas con el mismo email
4. **El token se guarda en almacenamiento seguro** - Persiste entre sesiones
5. **Al cerrar sesión** - El token se elimina del almacenamiento

---

## 🛠️ Debugging

### Ver Token Guardado
```dart
final auth = Provider.of<AuthProvider>(context);
print('Token: ${auth.token}');
print('User: ${auth.user?.nombreCompleto}');
print('Role: ${auth.role}');
```

### Ver Respuesta de API
Agregar prints en `AuthService`:
```dart
print('Response: $data');
```

### Ver Almacenamiento Seguro
```dart
final storage = FlutterSecureStorage();
final token = await storage.read(key: 'jwt_token');
print('Token almacenado: $token');
```

---

**Última actualización:** Diciembre 8, 2025
