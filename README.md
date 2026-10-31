# Vestiventa

Vestiventa es una aplicación web para administrar las ventas y compras de una tienda de ropa.

## Características

- Autenticación de usuarios con Devise.
- Gestión de prendas y ventas.
- Interfaz en español con estilos Tailwind CSS.

## Requisitos

Antes de instalar el proyecto, instala y comprueba que estén disponibles:

- Git.
- Ruby **3.3.6** (versión indicada en `.ruby-version`). Se recomienda usar un gestor de versiones como [rbenv](https://github.com/rbenv/rbenv) o [asdf](https://asdf-vm.com/).
- Bundler **2.6.9** (la versión del `Gemfile.lock`).
- PostgreSQL en ejecución, con una base de datos local accesible por TCP en `localhost:5432`.
- Las herramientas de compilación de Ruby y la biblioteca de desarrollo de PostgreSQL, necesarias para instalar la gema `pg` (por ejemplo, `build-essential` y `libpq-dev` en Debian/Ubuntu, o Xcode Command Line Tools y `libpq` en macOS).

En Windows, se recomienda instalar y ejecutar el proyecto dentro de WSL2 con una distribución Linux.

## Instalación y ejecución en desarrollo

1. Clona el repositorio. Reemplaza la URL de ejemplo por la URL real del repositorio:

	```sh
	git clone https://github.com/USUARIO/vestiventa.git
	cd vestiventa
	```

2. Selecciona Ruby 3.3.6 en tu gestor de versiones e instala Bundler 2.6.9 si aún no está instalado:

	```sh
	gem install bundler -v 2.6.9
	```

3. Comprueba la configuración de PostgreSQL. En desarrollo y pruebas, [config/database.yml](config/database.yml) usa `localhost`, el usuario `postgres` y la contraseña `postgres`. Configura PostgreSQL para aceptar esas credenciales o cambia esos valores en ese archivo para que coincidan con tu instalación local.

4. Ejecuta el instalador del proyecto:

	```sh
	bin/setup
	```

	Este comando instala las gemas, prepara la base de datos y levanta el servidor de desarrollo junto con el compilador de CSS. La primera ejecución puede tardar varios minutos. Para instalar y preparar todo sin iniciar el servidor, ejecuta `bin/setup --skip-server`; después, inicia la aplicación con `bin/dev`.

5. Abre [http://localhost:3000](http://localhost:3000) en el navegador. Crea una cuenta desde la opción de registro para empezar a usar la aplicación.

Para detener el servidor, pulsa `Ctrl+C` en la terminal donde está ejecutándose.

## Base de datos

La aplicación utiliza PostgreSQL. `bin/setup` ejecuta `bin/rails db:prepare`, que crea y migra la base de datos de desarrollo cuando hace falta. Para volver a ejecutar las migraciones manualmente:

```sh
bin/rails db:migrate
```

No se incluyen usuarios ni datos de demostración en las semillas actuales.

## Pruebas

Con las dependencias instaladas y PostgreSQL configurado, ejecuta:

```sh
bin/rails test
```

## Problemas frecuentes

- **Error de conexión o autenticación con PostgreSQL:** confirma que el servicio esté iniciado y que el usuario, contraseña, host y puerto coincidan con `config/database.yml`.
- **Falla la instalación de `pg`:** instala las herramientas de compilación y los archivos de desarrollo de PostgreSQL indicados en los requisitos; vuelve a ejecutar `bundle install`.
- **No se encuentra la versión de Ruby:** configura Ruby 3.3.6 en el gestor de versiones y vuelve a entrar al directorio del proyecto.
- **El puerto 3000 está ocupado:** detén la otra aplicación o inicia Rails en otro puerto con `PORT=3001 bin/dev`.

## Contribuciones

Las contribuciones son bienvenidas. Puedes reportar errores, proponer mejoras o enviar un pull request.

## Licencia

El README original indica que el proyecto usa la licencia MIT, pero no se encontró un archivo de licencia en la raíz del repositorio. Añade el archivo correspondiente para incluir los términos completos de la licencia.
