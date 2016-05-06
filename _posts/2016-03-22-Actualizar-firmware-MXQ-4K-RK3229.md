---
layout: post
categories: null
published: true
tags:
- Android
- MXQ-4K
title: "Actualizar firmware MXQ 4K"
image:
  url: /public/images/MXQ-4K_H.265_VP9_TV_Box.jpg
  width: 823
  height: 729
---


Geekbuying [ha publicado un nuevo firmware](http://blog.geekbuying.com/index.php/2016/03/21/mxq-4k-rk3229-smart-tv-box-firmware-update-2/). He aprovechado para probar la utilidades de rockchip e instalar el SuperSU desde el recovery

<!-- leer mas -->

Necesitaremos los siguientes archivos:

* [Recovery CWM]({{ site.data.metadata.lastCWM }}), comentado en el [post anterior]({% post_url 2016-02-26-Recovery-MXQ-4K-RK3229 %}).
* [Instalador de SuperSU](http://su.chainfire.eu/SuperSU-Embed.zip)



## Actualizar el firmware ##

Se asume que tenemos un sistema correctamente configurado para [acceder por ADB]({% post_url 2016-02-22-root-MXQ-4K-RK3229 %})

Hay que poner el aparato en modo bootloader. Se puede hacer encendiendo el aparato a la vez que se pulsa con un palillo el botón dento del puerto SPDIF. También se puede usar directamente `adb`.

```bash
$ adb reboot-bootloader
```
Una vez que el aparato esta el modo bootloader es necesario conectarlo por USB al puerto USB-4.

Las utilidades de rockchip se encuentran en multitud de repositorios, como  https://github.com/geekboxzone/utils o https://github.com/MozOpenHard/CHIRIMEN-tools

Únicamente es necesario descargarlo y ejecutar la utilidad de upgrade.

```bash
$ git clone https://github.com/geekboxzone/utils
$ cd utils
$ ./upgrade_tool uf /path/to/MXQ-4K_ota_20160308.img 
Loading firmware...
Support Type:RK322A    FW Ver:4.4.04    FW Time:2016-03-08 11:00:50
Loader ver:2.29    Loader Time:2016-01-26 20:19:51
Upgrade firmware ok.
```

[Este manual](http://wiki.radxa.com/Rock/flash_the_image) recoge las opciones con más detalle

## Reemplazar el recovery ##

El aparato se reiniciara automáticamente. Normalmente el flash del recovery se realiza por bootloader, pero también se puede instalar por adb sin necesidad de reiniciar.

Seleccionamos "Conectado a PC" en las opciones de USB para poder acceder por adb y ejecutamos lo siguiente.

```bash
adb push [archivo de recovery] /mnt/sdcard/recovery.img
adb shell "dd if=/mnt/sdcard/recovery.img of=/dev/block/rknand_recovery"
```

Para probar el recovery únicamente es necesario reiniciar en modo recovery

```bash
adb reboot recovery
```

El recovery funciona con las teclas de cursor y la tecla de encendido para ejecutar la opción seleccionada.

## Instalar SuperSU ##

La forma más fácil de instalarlo es entrar en el recovery que acabamos de instalar.

Dentro del recovery seleccionamos `install zip -> install zip from sideload`

Desde el PC, enviamos el [instalador de SuperSU](http://su.chainfire.eu/SuperSU-Embed.zip).

```bash
$ adb sideload /path/to/SuperSU-Embed.zip
```

Con esto tendremos solucionado el acceso root al dispositivo.
