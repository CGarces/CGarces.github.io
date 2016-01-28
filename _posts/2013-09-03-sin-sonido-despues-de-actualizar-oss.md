---
layout: post
title: Sin sonido después de actualizar oss-compat
date: '2013-09-03T01:22:00.001-07:00'
author: Carlos Garcés
tags:
- sonido
- Antix
- debian
- snd_hda_intel
modified_time: '2013-09-03T01:22:40.721-07:00'
blogger_id: tag:blogger.com,1999:blog-1928520019849450453.post-7320917716993357970
blogger_orig_url: http://pruebasconantix.blogspot.com/2013/09/sin-sonido-despues-de-actualizar-oss.html
---

Recientemente he tenido un problema al realizar un update desde la rama de
testing  
  
El ordenador se quedo sin sonido, mostrando el siguiente error durante el
arranque

```bash 
timeout: killing '/sbin/modprobe -bv pci:v000010ECd0000816Csv00001734sd00001178bc0Csc07i01' [594]  
```

<!-- leer mas -->
  
Efectivamente el dispositivo era la tajeta de sonido  
      
```bash 
root@antiX1:/home/Carlos# modprobe -R 'pci:v00008086d0000284Bsv00001025sd00000136bc04sc03i00'  
snd_hda_intel  
snd_hda_intel  
```

El modulo correspondiente no estaba cargado.  
  
```bash 
root@antiX1:/home/Carlos# rmmod snd-hda-intel  
Error: Module snd_hda_intel is not currently loaded  
```
  
Pero al cargarlo a mano, funcionaba correctamente  
  
```bash 
root@antiX1:/home/Carlos# modprobe snd-hda-intel  
```

Mirando en /var/log/kern.log pude determinar cuando dejo de funcionar  
  
```bash 
root@antiX1:/home/Carlos# less /var/log/kern.log | grep snd_hda_intel  
Sep  1 13:04:30 antiX1 kernel: [    9.238361] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X  
Sep  1 13:07:27 antiX1 kernel: [    7.969088] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X  
Sep  2 17:14:02 antiX1 kernel: [ 1465.338882] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X  
```  
    
El día 1 a las 13:07 se cargo durante el arranque y no volvió a cargarse hasta
el día 2 (cuando lo cargue a mano).  
El primer boot desde las 13:07 fue a las 17:09  
  
```bash 
Sep  1 17:09:44 antiX1 kernel: [    0.000000] Command line: root=UUID=419ad2c2-a347-4b58-ad65-eee0c6e57bbe ro pcie_aspm=force quiet  
```  
      
Asi que revise las actualizaciones entre las 13:07 y las 17:09 en _/var/log/apt/history.log_  
  
```bash 
Start-Date: 2013-09-01  13:58:42  
Commandline: apt-get upgrade  
Upgrade: oss-compat:amd64 (2, 4)  
End-Date: 2013-09-01  13:58:44  
```    

Después de eliminar el paquete _oss-compat_, el error no desapareció, así que
revise manualmente los ficheros de _/etc/modprobe.d/_ y vi que había un
archivo _oss-compat.conf_ (¿que debería haber eliminado apt-get?), una vez
eliminado manualmente la tarjeta de sonido volvió a funcionar con normalidad.
