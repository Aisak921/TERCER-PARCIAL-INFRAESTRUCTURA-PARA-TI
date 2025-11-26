# Imagen base ligera y soportada
FROM node:20-alpine

# Crear usuario no root para ejecutar la app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Directorio de trabajo
WORKDIR /usr/src/app

# Copiar solo definición de dependencias
COPY package*.json ./

# Copiar el resto del código
COPY . .

# Cambiar al usuario no root
USER appuser

# Exponer el puerto de la aplicación
EXPOSE 3000

# Comando de inicio
CMD ["npm", "start"]
