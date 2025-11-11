# README - Sistema de Facturación

## Requisitos
- Windows 11
- Permisos de Administrador
- 10 GB de espacio libre

---

## 1. Instalación de Oracle XE 21c

### Instalación
1. Descargar [Oracle XE 21c](https://www.oracle.com/database/technologies/xe-downloads.html)
2. Ejecutar instalador, establecer contraseña para SYS/SYSTEM
3. Puerto por defecto: `1521`

### Crear Usuario
```cmd
sqlplus sys as sysdba
```
```sql
ALTER SESSION SET CONTAINER = XEPDB1;
CREATE USER FACTU_MARKET IDENTIFIED BY Factu123;
GRANT CONNECT, RESOURCE, CREATE SESSION, UNLIMITED TABLESPACE TO FACTU_MARKET;
EXIT;
```

### Comandos Útiles
```cmd
net start OracleServiceXE          # Iniciar servicio
net stop OracleServiceXE           # Detener servicio
lsnrctl status                     # Ver estado
```

---

## 2. Instalación de .NET (ASP.NET Core)

1. Descargar [.NET SDK 8.0](https://dotnet.microsoft.com/download)
2. Ejecutar instalador
3. Verificar: `dotnet --version`

### Comandos Útiles
```cmd
dotnet restore      # Restaurar dependencias
dotnet build        # Compilar
dotnet run          # Ejecutar
```

---

## 3. Instalación de Ruby y Rails

### Ruby 3.3.6
1. Descargar [RubyInstaller 3.3.6 WITH DEVKIT](https://rubyinstaller.org/downloads/)
2. Instalar marcando: "Add to PATH" y "Run ridk install"
3. En MSYS2, presionar Enter para instalar todo
4. Verificar: `ruby --version`

### Rails 7.2.3
```cmd
gem install rails -v 7.2.3
gem install bundler
```

### Oracle Instant Client
1. Descargar [Oracle Instant Client](https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html)
2. Extraer en `C:\oracle\instantclient_21_13`
3. Agregar al PATH del sistema
4. Instalar: `gem install ruby-oci8`

---

## 4. Instalación de MongoDB

### MongoDB Community Server
1. Descargar [MongoDB 7.0](https://www.mongodb.com/try/download/community) (MSI)
2. Instalar como servicio (Complete installation)
3. Agregar al PATH: `C:\Program Files\MongoDB\Server\7.0\bin`

### MongoDB Shell
1. Descargar [mongosh](https://www.mongodb.com/try/download/shell) (ZIP)
2. Copiar `mongosh.exe` a `C:\Program Files\MongoDB\Server\7.0\bin`

### MongoDB Tools
1. Descargar [Database Tools](https://www.mongodb.com/try/download/database-tools) (ZIP)
2. Copiar todos los `.exe` a `C:\Program Files\MongoDB\Server\7.0\bin`

### Crear Base de Datos
```cmd
mongosh
```
```javascript
use rails_audit_db_development
db.createCollection("audits")
use rails_audit_db_test
db.createCollection("audits")
exit
```

### Comandos Útiles
```cmd
net start MongoDB       # Iniciar
net stop MongoDB        # Detener
mongosh                 # Conectar
```

---

## 5. Clonar el Proyecto
```cmd
cd C:\
mkdir Proyectos
cd Proyectos
git clone https://github.com/tu-usuario/tu-repositorio.git
cd tu-repositorio
```

---

## 6. Configuración Oracle

### database.yml
```yaml
default: &default
  adapter: oracle_enhanced
  username: FACTU_MARKET
  password: Factu123
  host: localhost
  port: 1521
  database: XEPDB1

development:
  <<: *default
test:
  <<: *default
production:
  <<: *default
```

### Configurar Base de Datos
```cmd
bundle install
rails db:setup          # Crea, migra y carga seeds
# O por separado:
# rails db:create
# rails db:migrate
# rails db:seed
```

---

## 7. Configuración MongoDB

### mongoid.yml
```yaml
development:
  clients:
    default:
      uri: <%= ENV.fetch("MONGODB_URI", "mongodb://localhost:27017/rails_audit_db_development") %>
  options:
    log_level: :warn
test:
  clients:
    default:
      uri: <%= ENV.fetch("MONGODB_URI", "mongodb://localhost:27017/rails_audit_db_test") %>
  options:
    log_level: :warn
production:
  clients:
    default:
      uri: <%= ENV.fetch("MONGODB_URI") %>
  options:
    log_level: :warn
```

Verificar en Rails console: `rails console`
```ruby
Mongoid.default_client.database.name
exit
```

---

## 8. Ejecutar el Proyecto

### Terminal 1 - Microservicio .NET
```cmd
cd microservices\ClientsService
dotnet restore
dotnet run
```
**URL:** `http://localhost:5000`

### Terminal 2 - Aplicación Rails
```cmd
cd C:\Proyectos\tu-repositorio
bundle install
rails server
```
**URL:** `http://localhost:3000`

---

## Comandos Rápidos

### Rails
```cmd
rails db:migrate:status    # Ver migraciones
rails db:rollback          # Revertir migración
rails console              # Consola interactiva
```

### Oracle
```cmd
sqlplus FACTU_MARKET/Factu123@localhost:1521/XEPDB1
```

### MongoDB
```cmd
mongosh
use rails_audit_db_development
show collections
db.audits.find()
```

---

## Solución Rápida de Problemas

**Oracle no inicia:** `net start OracleServiceXE`

**MongoDB no inicia:** `net start MongoDB`

**Rails error de migración:** `rails db:reset`

**Error de dependencias .NET:** `dotnet clean && dotnet restore`

**Error de gemas Ruby:** `bundle install`

---

## Soporte
- [Oracle Docs](https://docs.oracle.com/en/database/)
- [Rails Guides](https://guides.rubyonrails.org/)
- [.NET Docs](https://learn.microsoft.com/dotnet/)
- [MongoDB Docs](https://www.mongodb.com/docs/)
