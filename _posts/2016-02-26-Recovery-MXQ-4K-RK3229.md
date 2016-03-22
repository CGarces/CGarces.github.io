---
layout: post
categories: null
published: true
tags:
- Android
- MXQ-4K
title: "Recovery MXQ 4K"
image:
  url: /public/images/MXQ-4K_H.265_VP9_TV_Box.jpg
  width: 823
  height: 729
---

Después de [conseguir acceso root]({% post_url 2016-02-22-root-MXQ-4K-RK3229 %}) mi siguiente paso ha sido instalar un nuevo recovery. El que viene de serie es completamente inútil.

Después de leer un par de tutoriales sobre la compilación de CWM, he desistido de compilar el fuente directamente.

Por suerte la gente de crewrktablets tenia una serie de [recoverys para RockChip](http://crewrktablets.arctablet.com/?p=4776) que he podido usar como base para hacer un port.

<!-- leer mas -->

El recovery se encuentra disponible [en este enlace](https://mega.nz/#!WFglTQLL!tKnnPh-Ckw5nSHkvo3xjXcjjSdMve8EZCa7CyE225LE), pero explico los pasos para que puedan servir de guía en ports similares. Hay que tener en cuenta que es la 1º vez que realizo este proceso, así que es posible que pueda mejorarse en algún aspecto.


##Port de un recovery existente

Para realizar el port necesitaremos:

* [imgRePackerRK](http://forum.xda-developers.com/showthread.php?t=2257331), un empaquetador/desempaquetador de imágenes.
* [Recoverys](http://crewrktablets.arctablet.com/?p=4776) para RockChip.
* El recovery de la ROM del MXQ 4K, se puede extraer con [rkflashkit](https://github.com/linuxerwang/rkflashkit) o [rkflashtool](https://github.com/linux-rockchip/rkflashtool), o [descargala](https://mega.nz/#!qcxzzBDB!n3QaQ4KpHgLeKb3Hi8KYa_M6CTpJNG2tzr15g6kbPMQ) de mi backup. 

De las imágenes disponibles de crewrktablets yo he usado la de CWM `./rockdev/Image/CWM_CrewRKTablets_v1.1.img`

Descomprimimos imgRePackerRK y copiamos en el mismo directorio las dos imágenes.

Ejecutamos `imgrepackerrk` para desempaquetar las imágenes

```bash
$ imgrepackerrk CWM_CrewRKTablets_v1.1.img
$ imgrepackerrk CWM_CrewRKTablets_v1.1.img.unkrnl
$ imgrepackerrk recovery_stock.img
```
El contenido que nos interesa estara en los directorios `CWM_CrewRKTablets_v1.1.img_orig.unkrnl.dump` y `recovery_stock.img.dump/ramdisk.dump/`

Es necesario copiar los siguientes ficheros desde recovery_stock al recovery modificado.

```bash
$ cp recovery_stock.img.dump/ramdisk.dump/etc/recovery.fstab CWM_CrewRKTablets_v1.1.img_orig.unkrnl.dump/etc/recovery.fstab
$ cp recovery_stock.img.dump/ramdisk.dump/rk30xxnand_ko.ko.3.10.0  CWM_CrewRKTablets_v1.1.img_orig.unkrnl.dumprk30xxnand_ko.ko.3.10.0
```

El fichero `init.rc` es necesario modificarlo manualmente. Se necesitan ciertos conocimiento para hacerlo correctamente. En mi caso he conseguido que funcione el sideload, pero no he configurado bien las particiones.
Una vez modificado el fichero del stock recovery, se copia al recovery modificado.

```bash
$ cp recovery_stock.img.dump/ramdisk.dump/init.rc CWM_CrewRKTablets_v1.1.img_orig.unkrnl.dump/init.rc
```

Después de copiar los archivos, es necesario empaquetar de nuevo el recovery.

```bash
$ imgrepackerrk CWM_CrewRKTablets_v1.1.img.unkrnl.cfg 
$ imgrepackerrk CWM_CrewRKTablets_v1.1.img.cfg 
```

Reiniciamos en modo bootloader con `adb reboot-bootloader` y realizamos el flash.

El nuevo recovery reconoce el mando a distancia

* Teclas arriba/abajo para moverse por el menú.
* La tecla apagado para ejecutar la opción seleccionada.

Tener un recovery funcionar instalado nos permite realizar modificaciones de nuestro aparato teniendo con la seguridad de poder acceder a el en caso de problemas.
