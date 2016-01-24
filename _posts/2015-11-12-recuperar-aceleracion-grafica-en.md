---
layout: post
title: Recuperar aceleración gráfica en Chromium v.45
date: '2015-11-12T13:49:00.000-08:00'
author: Carlos Garcés
tags: 
- Antix
modified_time: '2015-11-12T13:49:37.559-08:00'
blogger_id: tag:blogger.com,1999:blog-1928520019849450453.post-529379821058590480
blogger_orig_url: http://pruebasconantix.blogspot.com/2015/11/recuperar-aceleracion-grafica-en.html
---

Recientemente me he comprado un portátil nuevo para reemplazar mi venerable
Asus 5315

He instalado la ultima versión de Lubuntu (15.10) para probar si merecía la
pena instalar la siguiente LTS. No me ha convencido, creo que probare la
ultima versión de Antix con Debian estable, sin systemd

Me he encontrado con un [bug de
regresión](https://code.google.com/p/chromium/issues/detail?id=509336)
bastante curioso.
<!--more-->

Comparando un par de [pruebas de rendimiento](https://dev.windows.com/en-us
/microsoft-edge/testdrive/demos/fishbowlie/) he visto que mi Acer 5315 con un
T8100 es mas rápido que mi Lenovo G50-80 con un intel 3205U.

Es verdad que el T8100 tiene una frecuencia mas alta (mas fuera bruta) pero me
esperaba verlo compensado al apoyarse en una GPU mejor

Revisando mejor las pruebas he visto que la versión de Chromium que estoy
usando (45.0.2454.101) no tenia el canvas acelerado por hardware.

Para solucionar el bug he cambiado el .desktop que lanza el navegador.

Tan sencillo como editar el fichero

{% highlight bash %}     
$ sudo leafpad /usr/share/applications/lxde-x-www-browser.desktop 
{% endhighlight %}

Y añadir el parametro --ignore-gpu-blacklist

  
{% highlight bash %}     
_Exec=/usr/bin/x-www-browser --ignore-gpu-blacklist %u_
{% endhighlight %}
