---
layout: post
title: Como redimensionar una partición NTFS con sectores dañados
date: '2013-05-31T15:52:00.001-07:00'
author: Carlos Garcés
tags:
- testdisk
- NTFS
- Antix
- GParted
modified_time: '2013-05-31T15:56:24.801-07:00'
blogger_id: tag:blogger.com,1999:blog-1928520019849450453.post-7156944579357089360
blogger_orig_url: http://pruebasconantix.blogspot.com/2013/05/como-redimentionar-una-particion-ntfs.html
---

  
Estos son los pasos que he seguido para instalar Antix en un disco duro IDE
160GB con Windows XP en una partición NTFS con sectores defectuosos  
  
Como el disco NTFS tiene sectores mal, GParted se niega a trabajar. Hay que
hacer que ntfsresice ejecute todas las instrucciones con el parámetro --bad-
sectors  

<!-- leer mas -->
  
Podría haber hecho algo así:  

```bash
    cp /usr/bin/ntfsresize to /usr/bin/ntfsresize.orig  
```

Y luego un bash  
  
```bash
    #!/bin/bash  
    exec ntfsresize.orig --bad-sectors "$@"  
```

Pero no he sabido como hacerlo ya que no me dejaba modificar los ficheros del
liveCD  

  
Tiro de [este post](http://pchelppma.blogspot.com.es/2008/11/mover-o-redimensionar-particiones-ntfs_13.html) para hacer el proceso a mano:  
  
Borro la partición y le asigno el tamaño ~~correcto~~.  
  
En este punto cometo algún error al calcular el cilindro donde debería acabar
la partición  GParted deja de reconocerme la partición NTFS, no le hago caso y
hago las particiones EXT4 y Swap e instalo Linux (otro error mas)  
  
Con Linux funcionado me empiezo a preocupar por la partición NTFS  
  
Consigo arrancar con un CD antiguo (de hace 6 años!) que tenia por ahí  para
intentar hacer un chkdsk, sin éxito.  
Por fortuna el CD venia con
[TestDisk](http://www.cgsecurity.org/wiki/TestDisk). Lo malo es que me
reconoce la partición NTFS (y la arregla) pero no las otras dos (EXT4 y swap).  
Como realmente no tenia nada critico en las otras dos particiones no hay
problema (salvo la considerable perdida de tiempo) en volverlas a crear  de
cero y ejecutar de nuevo la instalación de Antix.
