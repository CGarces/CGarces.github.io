---
layout: post
title: Instalar Mesa 9.x en Debian
date: '2013-06-03T10:15:00.004-07:00'
author: Carlos Garcés
tags:
- intel
- mesa
- experimental
- debian
modified_time: '2013-06-03T10:16:42.951-07:00'
blogger_id: tag:blogger.com,1999:blog-1928520019849450453.post-8619802290033514061
blogger_orig_url: http://pruebasconantix.blogspot.com/2013/06/instalar-mesa-9x-en-debian.html
---

Recientemente [se ha incluido la versión 9 de Mesa en la rama experimental de
Debían](http://packages.qa.debian.org/m/mesa/news/20130528T212711Z.html)  
  
Esto hace que ahora sea relativamente sencillo instalar esta nueva versión en
cualquier distribución basada en Debian que aun no lo tenga en sus
repositorios.  
<!--more-->
  
Lo primero es añadir la rama experimental en la lista de repositorios  

{% highlight bash %} 
###### Debian Experimental##########
deb http://ftp.rediris.es/debian/ experimental main contrib non-free
{% endhighlight %}
  
Para asegurarnos de que no actualizamos mas cosas de la cuenta modificamos la
configuración  
  
{% highlight bash %} 
$ nano /etc/apt/apt.config

APT::Install-Recommends "0";  

APT::Install-Suggests "0";  

APT::Default-Release "testing";  
{% endhighlight %}
    

  
En mi caso uso el repositorio de "testing", cambiarlo con el repositorio que
corresponda en vuestro caso.  
  
Ahora solo queda actualizar la lista de paquetes  
  
{% highlight bash %} 
$ apt-get update
{% endhighlight %}

E instalar los paquetes implicados, con el parámetro -t experimental  
  
{% highlight bash %} 
$ apt-get install xserver-xorg-video-intel  libgl1-mesa-glx libgl1-mesa-dri xserver-xorg-core -t experimental
    
    
    Leyendo lista de paquetes... Hecho  
      
    Creando árbol de dependencias        
      
    Leyendo la información de estado... Hecho  
      
    xserver-xorg-core ya está en su versión más reciente.  
      
    Se instalarán los siguientes paquetes extras:  
      
      libdrm-dev libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 libdrm2 libffi5 libgl1-mesa-dev libglapi-mesa libkms1 libllvm3.2 libx11-xcb-dev libxcb-dri2-0-dev  
      
      libxcb-glx0-dev mesa-common-dev  
      
    Paquetes sugeridos:  
      
      libglide3  
      
    Paquetes recomendados:  
      
      libtxc-dxtn0  
      
    Se instalarán los siguientes paquetes NUEVOS:  
      
      libdrm-dev libdrm-nouveau2 libffi5 libkms1 libllvm3.2 libx11-xcb-dev libxcb-dri2-0-dev libxcb-glx0-dev  
      
    Se actualizarán los siguientes paquetes:  
      
      libdrm-intel1 libdrm-radeon1 libdrm2 libgl1-mesa-dev libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa mesa-common-dev xserver-xorg-video-intel  
      
    9 actualizados, 8 se instalarán, 0 para eliminar y 158 no actualizados.  
      
    Necesito descargar 18,6 MB de archivos.  
      
    Se liberarán 8.331 kB después de esta operación.  
      
    ¿Desea continuar [S/n]? S  
{% endhighlight %}
      
Solo queda realizar un par de pruebas para comprobar que todo funciona
correctamente.  
En mi caso hay una [ligera mejora de
rendimiento](http://openbenchmarking.org/result/1305294-FO-SNAVSUXA615)
gracias a los cambios introducidos por intel en sus ultimas versiones.  
