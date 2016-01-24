---
layout: post
title: Configuración de una SIS 761GX
date: '2007-04-25T10:26:00.000-07:00'
author: Carlos Garcés
tags: 
- mesa
- xubuntu
modified_time: '2007-04-25T10:53:04.080-07:00'
blogger_id: tag:blogger.com,1999:blog-7171856089616316267.post-8748392899277610710
blogger_orig_url: http://xubuntu-es.blogspot.com/2007/04/configuracion-de-una-sis-761gx.html
---

Si tenéis pensado instalar Linux en vuestro ordenador yo
me aseguraría que la placa base no use chipset SIS, el soporte de esta
compañía hacia Linux no es precisamente bueno  
  
La instalación de XUbuntu (mas concretamente el servidor X) no detecta
correctamente la tarjeta gráfica, instalando el driver genérico "VESA", que
funciona pero su rendimiento no es aceptable.  
<!--more-->
  
Lo primero es seleccionar el driver correcto, modificando el fichero de
configuración.  

{% highlight bash %}   
sudo mousepad /etc/X11/xorg.conf  
{% endhighlight %}
   
Buscar en el fichero el valor "vesa" y sustituirlo por "sis"  
  
También se puede usar la interfaz de configuración del servidor X  
  
{% highlight bash %}   
sudo dpkg-reconfigure xserver-xorg  
{% endhighlight %}
  
Aconsejo el 1° método ya que es mas rápido, e incluso mas sencillo, puesto que
al reconfigurar el servidor X habrá que especificarle todas las opciones del
servidor (teclado, ratón, tasa de refresco, ect...)  
  
El siguiente escollo es la reproducción de vídeos. Tanto xine como MPlayer
(los motores de reproducción mas extendidos), seleccionan mal el modo de video
a usar, con lo cual hay que forzarlos a usar el único modo que funciono
correctamente en mi tarjeta, X11 en MPlayer o xshm en Xine (X11 with SHM
extension).
  
Tanto Gxine como xfmedia me daban algún problema (se quedaban residentes y
debía matar las tareas) decidí eliminar estas aplicaciones e instalarme el
motor de [MPlayer](http://www.mplayerhq.hu/). Después de configurar el modo
X11 dentro de GMPlayer (una GUI en GTK) tuve algun problema para ver el video
en pantalla completa (no reescalaba el vídeo, y lo veía dentro de un
recuadro), pera solucionar estos problemas edite el fichero config, que define
las opciones por defecto.  

{% highlight bash %}     
./MPlayer/config  
# Write your default config options here!  
vo=x11  
zoom=1  
fs=on  
{% endhighlight %}
  
Mi tarjeta sigue sin tener soporte 3d, pero esto no es un problema para jugar
a [Freeciv](http://www.freeciv.org) y ahora ya puedo ver vídeos correctamente.

