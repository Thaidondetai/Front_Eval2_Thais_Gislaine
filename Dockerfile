#Imagen
FROM python:3.11-slim AS builder

#Establecer el directorio de trabajo
WORKDIR /app

#Variables para optimizar la ejecución de Python en Docker
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

#Instalar las dependencias necesarias para compilar las dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.11-slim

#Crear un usuario no root para ejecutar la aplicación de forma segura
RUN useradd -m appuser

WORKDIR /app

#Copiar dependencias desde builder
COPY --from=builder /app /app

#Copia el resto de los archivos del poyecto
COPY . .

#Darle permisos al usuario creada para acceder a los archivos de la aplicación
RUN chown -R appuser:appuser /app

#Cambiar al usuario no root para ejecutar la aplicación de forma segura
USER appuser

#Exponer el puerto en el que la aplicación se ejecutará
EXPOSE 5000

#Iniciar Flask al ejecutar el contenedor
CMD [ "python", "app.py" ]