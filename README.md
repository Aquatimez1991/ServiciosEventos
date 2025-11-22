# PartyApp - Aplicación de Servicios de Eventos (Flutter)

Aplicación móvil Flutter para Android que permite a los usuarios buscar y contratar servicios para eventos, y a los proveedores gestionar sus servicios.

## Características

- 🔐 Autenticación automática con Google Sign-In (Android)
- 🏪 Catálogo completo de proveedores de servicios (6 proveedores, 23+ servicios)
- 🛒 Carrito de compras
- 💳 Proceso de pago
- 📱 Dashboard para proveedores
- 🎨 Interfaz moderna y atractiva

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/                   # Modelos de datos
│   ├── service.dart
│   ├── provider_model.dart
│   ├── cart_item.dart
│   ├── user.dart
│   └── auth_user.dart
├── providers/                # Gestión de estado (Provider pattern)
│   ├── app_provider.dart
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   └── provider_provider.dart
├── screens/                  # Pantallas de la aplicación
│   ├── loader_screen.dart
│   ├── login_screen.dart
│   ├── register_customer_screen.dart
│   ├── register_provider_screen.dart
│   ├── home_screen.dart
│   ├── provider_detail_screen.dart
│   ├── cart_screen.dart
│   ├── auth_info_screen.dart
│   ├── payment_screen.dart
│   ├── confirmation_screen.dart
│   ├── provider_dashboard_screen.dart
│   └── add_service_screen.dart
├── services/                 # Servicios y APIs
│   └── api_service.dart      # ⚠️ Comentado para integración con backend
├── utils/                    # Utilidades
│   ├── app_theme.dart
│   └── formatters.dart
└── widgets/                  # Widgets reutilizables
    └── provider_card.dart
```

## Integración con Backend

⚠️ **IMPORTANTE**: Los servicios de API están comentados y listos para integrar con el backend.

### Archivo: `lib/services/api_service.dart`

Este archivo contiene todos los métodos de API comentados con documentación sobre:
- Endpoints esperados
- Parámetros requeridos
- Formato de respuesta

### Pasos para integrar:

1. **Configurar URL base del backend**:
   ```dart
   static const String baseUrl = 'https://tu-backend.com';
   ```

2. **Descomentar los métodos necesarios** en `api_service.dart`

3. **Actualizar los providers** para usar los métodos reales en lugar de mocks:
   - `lib/providers/auth_provider.dart`
   - `lib/providers/provider_provider.dart`

4. **Agregar manejo de tokens de autenticación**:
   - Los métodos de API esperan un token en los headers
   - Implementar almacenamiento seguro de tokens (usar `flutter_secure_storage`)

### Endpoints esperados:

#### Autenticación
- `POST /api/auth/login` - Login de usuario
- `POST /api/auth/register/customer` - Registro de cliente
- `POST /api/auth/register/provider` - Registro de proveedor

#### Proveedores
- `GET /api/providers` - Listar proveedores (con filtros opcionales)
- `GET /api/providers/:id` - Obtener proveedor por ID

#### Servicios
- `POST /api/services` - Crear servicio (requiere autenticación)
- `PUT /api/services/:id` - Actualizar servicio (requiere autenticación)
- `DELETE /api/services/:id` - Eliminar servicio (requiere autenticación)

#### Órdenes
- `POST /api/orders` - Crear orden (requiere autenticación)
- `GET /api/orders` - Obtener órdenes del usuario (requiere autenticación)

## Instalación

1. Asegúrate de tener Flutter instalado (versión 3.0.0 o superior)

2. Clona el repositorio:
   ```bash
   git clone <repository-url>
   cd party_app
   ```

3. Instala las dependencias:
   ```bash
   flutter pub get
   ```

4. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## Dependencias Principales

- `provider` - Gestión de estado
- `go_router` - Navegación
- `http` - Cliente HTTP para APIs
- `cached_network_image` - Carga y caché de imágenes
- `intl` - Formateo de números y fechas
- `uuid` - Generación de IDs únicos
- `google_sign_in` - Autenticación automática con Google (Android)

## Autenticación

La aplicación usa **autenticación automática con Google Sign-In** para Android. Al iniciar la app:
1. Se intenta autenticar silenciosamente con la cuenta de Google del dispositivo
2. Si no hay sesión activa, se solicita el login con Google
3. Si Google Sign-In no está disponible, se crea un usuario demo automáticamente

**Nota**: La pantalla de login manual ha sido removida ya que Android maneja la autenticación automáticamente.

## Notas de Desarrollo

- Los datos actualmente son mock data para desarrollo
- Todas las llamadas a API están comentadas y listas para descomentar cuando el backend esté disponible
- La aplicación está optimizada para Android
- El diseño sigue Material Design 3

## Próximos Pasos

1. ✅ Migración a Flutter completada
2. ⏳ Integrar con backend (descomentar servicios API)
3. ⏳ Agregar almacenamiento local para persistencia
4. ⏳ Implementar notificaciones push
5. ⏳ Agregar pruebas unitarias y de integración

## Licencia

Este proyecto es privado y está destinado únicamente para uso interno.
