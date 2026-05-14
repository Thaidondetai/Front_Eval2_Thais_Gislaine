#Imagen base de Python 3.11 slim
FROM python:3.11-slim AS builder

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Evita los archivos .pyc y mejora logs en Docker
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copia el archivo de dependencias
COPY requirements.txt .

# Instala dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

#Imagen final para ejecutar la aplicación
FROM python:3.11-slim

# Creacion del usuario no root
RUN useradd -m appuser

# Directorio de trabajo
WORKDIR /app

# Copia SOLO las dependencias instaladas desde la etapa builder para evitar copiar archivos innecesarios y reducir el tamaño de la imagen

COPY --from=builder /usr/local/lib/python3.11 /usr/local/lib/python3.11
COPY --from=builder /usr/local/bin /usr/local/bin

# Copiar el código de la aplicación
COPY . .

# Dar permisos al usuario sobre los archivos
RUN chown -R appuser:appuser /app

# Cambiar a usuario no root
USER appuser

# Exponer el puerto donde corre Flask
EXPOSE 5000

# Comando para iniciar la aplicación
CMD ["python", "app.py"]