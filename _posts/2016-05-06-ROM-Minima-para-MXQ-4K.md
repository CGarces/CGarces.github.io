---
layout: post
categories: null
published: true
tags:
- Android
- MXQ-4K
title: "ROM Mínima para MXQ-4K"
image:
  url: /public/images/info.png
  width: 1280
  height: 720
---

Después de limpiar la ROM original, para dejarla a mi gusto, he decidido empaquetar todo en una ROM por si pudiera ser útil para otros usuarios de este aparato. Además así aprovecho para mejorar mis conocimientos de Andriod

La ROM esta basada en la versión de fabrica del 8 de Marzo de 2016 con las siguientes modificaciones:

* [Recovery CWM]({{ site.data.metadata.lastCWM }}), creado en [este post anterior]({% post_url 2016-02-26-Recovery-MXQ-4K-RK3229 %}).
* Permisos root con superSU instalado.
* Kernel de la ROM 30032016.
* Eliminadas **TODAS** las aplicaciones de fabrica.
* Google Play Store instalado con las dependencias mínimas.

NOTA. Esta ROM funciona si tienes una ROM igual o superior a la 08032016. Si lo instalas desde la 27022016 se producirá un bootloop que no he sabido solucionar.

<!-- leer mas -->

## Actualizar el firmware ##

[Descarga la ROM]({{ site.data.metadata.ROM1 }}) y busca un cable USB A - A para realizar el proceso de flash.

Con Linux el flash se puede realizar con la utilidad `upgrade_tool` ya explicada [este post]({% post_url 2016-03-22-Actualizar-firmware-MXQ-4K-RK3229 %})

Para Windows no lo he probado, pero el siguiente proceso debería funcionar.

1. Conectar al PC con un cable USB A-to-USB A por el puerto USB-4
2. Habilitar “USB Debugging” y “Connect to PC” en los ajustes.
3. Instalar [DriverAssistant y AndroidTool](https://github.com/MozOpenHard/CHIRIMEN-tools)
4. Instalar manualmente el driver.
5. Abrir AndroidTool v2.33, cargar el firmware y hacer el flash.

Yo no uso Windows así que no puedo dar mas detalles.

Una vez realizado el flash, el aparato intentara arrancar. Puede tardar un poco en realizar el primer arranque (5 minutos) o puede no arrancar.

Si no arranca (muestra el logo durante mas de 5 minutos), puede ser debido a los datos de cache. Sera necesario entrar en modo recovery y realizar un borrado de la cache.

## Iniciar en modo recovery ##

1. Dejar pulsado el botón físico del conector AV (con un palillo o similar).
2. Alimentar el dispositivo. Si estas alimentando el aparato por USB, asegúrate que lo conectas a un USB diferente del USB-4.
3. Dejar pulsado hasta que aparezca el logo MXQ-4K.
3. Una vez dentro del recovery, seleccionar "Wipe Cache" y "wipe dalvik-cache" dentro de las opciones avanzadas.

## Detalles de la ROM ##

Como se puede ver en la imagen, se han eliminado todas las aplicaciones de fabrica, dejando la ROM limpia.

![Aplicaciones de sistema](/public/images/rom/aplicaciones.jpg)

La instalación deja 4.29 GB libres para instalar aplicaciones. Más que suficiente para una instalacion de KODI si los archivos multimedia están en un disco duro externo.

![Espacio libre](/public/images/rom/almacenamiento.jpg)

El kernel sigue siendo el mismo que en el resto de stock ROM que han salido, 3.10.0. He usado la ultima compilación que he encontrado (22 Marzo) aunque no he visto cambios.

![Aplicaciones de sistema](/public/images/rom/info.jpg)

Es la primera ROM que empaqueto, cualquier comentario de algún cocinero con experiencia sera bienvenido, en especial si me ayuda con el bootloop y un par de dudas con el recovery.
