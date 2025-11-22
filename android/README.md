# Configuración Android

## Estructura creada

La estructura básica de Android ha sido creada. Para ejecutar la aplicación en un dispositivo Android:

1. Asegúrate de tener Flutter instalado y configurado
2. Conecta un dispositivo Android o inicia un emulador
3. Ejecuta: `flutter run`

## Configuración de Google Sign-In (Opcional)

Para habilitar Google Sign-In en producción:

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la API de Google Sign-In
4. Crea credenciales OAuth 2.0 para Android
5. Obtén el SHA-1 de tu keystore:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
6. Agrega el SHA-1 a las credenciales OAuth en Google Cloud Console
7. Descarga el archivo `google-services.json` y colócalo en `android/app/`

## Nota

Por ahora, la aplicación funciona con autenticación demo automática si Google Sign-In no está configurado.

