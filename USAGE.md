# Hosts Updater - Sistema de Protección de Hosts

## 🎯 Objetivo
Este sistema protege tu archivo `/etc/hosts` detectando cualquier modificación y restaurando automáticamente tu configuración con los bloqueos personalizados + lista de bloqueo.

## 📋 ¿Cómo Funciona?

1. **Archivo Base**: `hosts` - Contiene tus bloqueos personalizados (ej: www.renzodus.com)
2. **Lista de Bloqueo**: Se descarga automáticamente de StevenBlack/hosts
3. **Monitor**: El servicio launchd vigila `/etc/hosts` constantemente
4. **Protección**: Si alguien (tú o una app) modifica `/etc/hosts`, el script lo detecta y restaura tu configuración

## 🚀 Instalación

```bash
sudo ./macos-setup.sh
```

Esto:
- ✅ Instala el servicio de monitoreo
- ✅ Actualiza `/etc/hosts` inmediatamente
- ✅ Crea backups automáticos
- ✅ Configura logs

## 🧪 Prueba

```bash
./test-watcher.sh
```

Luego en otra terminal:
```bash
sudo nano /etc/hosts
# Haz un cambio y guarda
# Verás que se restaura automáticamente
```

## 📝 Agregar Más Bloqueos

Edita el archivo `hosts` en este directorio:
```bash
nano hosts
```

Agrega tus sitios al final:
```
127.0.0.1 sitio-a-bloquear.com
127.0.0.1 www.sitio-a-bloquear.com
```

Luego actualiza manualmente:
```bash
sudo ./hosts-updater.sh
```

## 🗑️ Desinstalar

```bash
sudo ./macos-uninstall.sh
```

## 📊 Logs

- `hosts_update.log` - Registro de actualizaciones
- `launchd-stdout.log` - Salida estándar del servicio
- `launchd-stderr.log` - Errores del servicio

## 🔍 Comandos Útiles

```bash
# Ver estado del servicio
sudo launchctl list | grep hostupdater

# Ver logs en tiempo real
tail -f hosts_update.log

# Actualizar manualmente
sudo ./hosts-updater.sh

# Ver el archivo /etc/hosts actual
cat /etc/hosts
```

## ⚠️ Notas Importantes

1. **Protección Continua**: Una vez instalado, cualquier cambio a `/etc/hosts` será detectado y revertido automáticamente
2. **Backups**: Cada actualización crea un backup en `/etc/hosts.backup`
3. **Sin Bucles**: El script verifica si hay cambios reales antes de actualizar, evitando bucles infinitos
4. **Permisos**: Requiere sudo/root para funcionar

## 🎯 Casos de Uso

- **Auto-control**: Bloquear sitios distractores y evitar que te des permiso de acceder
- **Bloqueo parental**: Proteger el sistema de modificaciones no autorizadas
- **Seguridad**: Mantener lista de bloqueo actualizada contra malware/tracking
- **Privacidad**: Bloquear redes publicitarias y trackers

## 🛠️ Solución de Problemas

### El servicio no se inicia
```bash
sudo launchctl unload /Library/LaunchDaemons/com.hostupdater.plist
sudo launchctl load /Library/LaunchDaemons/com.hostupdater.plist
```

### Ver errores del servicio
```bash
cat launchd-stderr.log
```

### Verificar que el plist es válido
```bash
plutil -lint /Library/LaunchDaemons/com.hostupdater.plist
```
