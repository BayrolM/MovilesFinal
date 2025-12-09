# Crear Usuario Admin - Instrucciones

Para crear un usuario admin correctamente, sigue estos pasos:

## Opción 1: Usar cURL (Terminal/PowerShell)

```bash
curl -X POST https://back02-y3wc.vercel.app/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{
    \"id_rol\": 1,
    \"tipo_documento\": \"CC\",
    \"documento\": \"0000000001\",
    \"nombres\": \"Admin\",
    \"apellidos\": \"Usuario\",
    \"email\": \"admin@makeup.com\",
    \"telefono\": \"3001234567\",
    \"direccion\": \"Calle Admin 123\",
    \"ciudad\": \"Bogotá\",
    \"password\": \"Admin@123456\"
  }"
```

## Opción 2: Usar Postman

1. **Abre Postman**
2. **Crea una nueva request:**
   - Método: `POST`
   - URL: `https://back02-y3wc.vercel.app/api/auth/register`
   - Headers: `Content-Type: application/json`

3. **Body (JSON):**
```json
{
  "id_rol": 1,
  "tipo_documento": "CC",
  "documento": "0000000001",
  "nombres": "Admin",
  "apellidos": "Usuario",
  "email": "admin@makeup.com",
  "telefono": "3001234567",
  "direccion": "Calle Admin 123",
  "ciudad": "Bogotá",
  "password": "Admin@123456"
}
```

4. **Presiona Send**

---

## Credenciales del Admin creado:

```
Email:    admin@makeup.com
Password: Admin@123456
id_rol:   1
```

---

## Luego de crear el usuario:

1. Abre la app Flutter
2. Ingresa a **CREAR CUENTA** y registra un usuario cliente normal:

```json
{
  "id_rol": 2,
  "tipo_documento": "CC",
  "documento": "1234567890",
  "nombres": "Juan",
  "apellidos": "Pérez",
  "email": "juan@makeup.com",
  "telefono": "3001234567",
  "direccion": "Calle 123",
  "ciudad": "Bogotá",
  "password": "Cliente@123"
}
```

---

## Troubleshooting:

Si obtienes error 400 "Usuario ya existe":
- Usa un email y documento diferentes
- Por ejemplo: `admin2@makeup.com`, documento `0000000002`

Si obtienes error 500:
- Verifica que todos los campos estén presentes
- Revisa la consola del backend en Vercel
