
# Countries Graph - Flutter App

## Descripción

Este es un proyecto Flutter que utiliza la API GraphQL de [Graph Countries](https://github.com/lennertVanSever/graphcountries) para consultar y mostrar información sobre países de diferentes regiones. La aplicación permite al usuario seleccionar una región y obtener la lista de países correspondientes, mostrando su nombre, capital y bandera en forma de emoji.

## Características

- **Selección de región:** Permite al usuario seleccionar una de las siguientes regiones: África, América, Asia, Europa, y Oceanía.
- **Consulta GraphQL:** Realiza consultas a la API GraphQL de Graph Countries para obtener información sobre los países de la región seleccionada.
- **Interfaz dinámica:** La lista de países se actualiza dinámicamente según la región seleccionada.
- **Interfaz sencilla:** Muestra el nombre del país, la capital y la bandera en formato emoji.

## Requisitos

- Flutter 3.0.0 o superior.
- Dart 2.12 o superior.
- Conexión a Internet para realizar las consultas a la API.

## Instalación

### 1. Clona el repositorio

```bash
git clone https://github.com/tu-usuario/countries_graph.git
```

### 2. Navega a la carpeta del proyecto

```bash
cd countries_graph
```

### 3. Instala las dependencias

Ejecuta el siguiente comando para obtener las dependencias necesarias:

```bash
flutter pub get
```

### 4. Ejecuta la aplicación

Puedes ejecutar la aplicación utilizando el siguiente comando:

```bash
flutter run
```

## Estructura del Proyecto

El proyecto tiene la siguiente estructura de archivos:

```
countries_graph/
├── lib/
│   ├── main.dart            # Código principal de la aplicación
├── pubspec.yaml             # Archivo de configuración de dependencias
├── README.md                # Este archivo
└── ...
```

## Dependencias

Este proyecto utiliza las siguientes dependencias:

- `http`: Para realizar solicitudes HTTP a la API GraphQL de Graph Countries.

## Contribuciones

Si deseas contribuir a este proyecto, puedes hacerlo siguiendo estos pasos:

1. Haz un fork de este repositorio.
2. Crea una rama para tus cambios (`git checkout -b feature/mi-nueva-caracteristica`).
3. Haz commit de tus cambios (`git commit -am 'Añadí una nueva característica'`).
4. Empuja tus cambios a tu fork (`git push origin feature/mi-nueva-caracteristica`).
5. Abre un pull request.

## Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

## Agradecimientos

- [Graph Countries API](https://github.com/lennertVanSever/graphcountries) por ofrecer una API gratuita y sin restricciones para obtener datos de países.
- La comunidad de Flutter y Dart por su excelente documentación y soporte.
