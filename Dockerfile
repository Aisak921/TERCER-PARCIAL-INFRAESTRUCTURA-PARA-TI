# Imagen base ligera y soportada
FROM node:22-alpine

# Crear usuario no root para ejecutar la app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Directorio de trabajo
WORKDIR /usr/src/app

# Copiar solo definición de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm install --legacy-peer-deps

# Copiar el resto del código y asignar permisos al usuario no root
COPY --chown=appuser:appgroup . .

# Cambiar al usuario no root
USER appuser

# Exponer el puerto de la aplicación
EXPOSE 3000

# Comando de inicio
CMD ["npm", "start"]
