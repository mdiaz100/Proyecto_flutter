
# 🛍️ E-commerce Flutter App

Este es un **proyecto de e-commerce desarrollado en Flutter**, que consume la API pública de [DummyJSON](https://dummyjson.com/).  
La aplicación permite **listar productos, buscarlos, crear, editar y eliminar**, mostrando un flujo completo de un CRUD básico para un catálogo en línea.

---

## 🌐 API utilizada: DummyJSON

Se usa la API **[DummyJSON](https://dummyjson.com/)**, que es un servicio gratuito de prueba ideal para simular datos de e-commerce.  
Los endpoints más relevantes usados en este proyecto son:

- **Obtener productos**:  
  ```http
  GET https://dummyjson.com/products?limit=10&skip=0


* **Buscar productos**:

  ```http
  GET https://dummyjson.com/products/search?q=producto
  ```

* **Obtener producto por ID**:

  ```http
  GET https://dummyjson.com/products/{id}
  ```

* **Crear producto**:

  ```http
  POST https://dummyjson.com/products/add
  ```

* **Actualizar producto** (PUT / PATCH):

  ```http
  PUT https://dummyjson.com/products/{id}
  PATCH https://dummyjson.com/products/{id}
  ```

* **Eliminar producto**:

  ```http
  DELETE https://dummyjson.com/products/{id}
  ```

📌 **Nota:** DummyJSON no persiste los cambios realmente en la base de datos.
Es decir, los productos creados o editados funcionan en tiempo de ejecución, pero se restablecen al hacer nuevas peticiones.

---

## 📱 Funcionalidades del proyecto

* ✅ Listado de productos con scroll infinito.
* ✅ Búsqueda de productos por nombre o descripción.
* ✅ Detalle de producto con imagen, precio, categoría, etc.
* ✅ Creación de nuevos productos (dummy).
* ✅ Edición de productos existentes.
* ✅ Eliminación de productos.

---

## 🛠️ Tecnologías utilizadas

* [Flutter](https://flutter.dev/) (Frontend)
* [Provider](https://pub.dev/packages/provider) (Gestión de estado)
* [Dio](https://pub.dev/packages/dio) (Cliente HTTP)
* [DummyJSON API](https://dummyjson.com/) (Datos de ejemplo)

---

## 🚀 Cómo iniciar el proyecto

1. **Clonar el repositorio**

   ```bash
   git clone https://github.com/tuusuario/tu-repo.git
   cd tu-repo
   ```

2. **Instalar dependencias**

   ```bash
   flutter pub get
   ```

3. **Ejecutar en un emulador o dispositivo físico**

   ```bash
   flutter run
   ```


---

## 🎥 Video demostrativo

👉 Aquí puedes ver el funcionamiento completo de la aplicación en YouTube:

[!Ver video](https://youtube.com/watch?v=ID_DEL_VIDEO)

---
