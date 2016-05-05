---
layout: post
categories: null
published: true
tags:
- Android
- MXQ-4K
title: "Root en MXQ-4K, método simplificado"
image:
  url: /public/images/MXQ-4K_H.265_VP9_TV_Box.jpg
  width: 823
  height: 729
---

Tras visitar un [conocido foro ruso](http://4pda.ru/forum/index.php?showtopic=723460) sobre dispositivos Android, me visto que hay una aproximación más sencilla para obtener el root.
El script directamente modifica el recovery del dispositivo, en lugar de intentar hacer uso de algún exploit conocido.

Es simple sencillo y debería funcionar también en Windows (aunque solo lo he probado en Linux)

El unico problema es que al modificar el recovery, este script puede no ser compatible con otros dispositivos. *No usar este metodo en otros aparatos*

<!-- leer mas -->

## Explicacion del proceso ##

Si solo estas interesado en el root, puedes saltarte esta sección e ir directo a la parte donde se explica como ejecutarlo.

El proceso consta de dos scripts, uno se ejecuta en nuestro PC y el otro es ejecutado internamente por el recovery.

El primer script (root.bat o root.sh según el sistema operativo), se encuentra en el directorio raiz del fichero comprimido.

* Monta el sistema el lectura/escritura.

```shell
adb remount
```

* Sube el contenido del directorio tmp al dispositivo.

```shell
adb push tmp /mnt/sdcard/tmp/
```

* Sobreescribe la partición `/dev/block/rknand_recovery`, instalando el nuevo recovery.

```shell
adb shell "dd if=/mnt/sdcard/tmp/recovery.img of=/dev/block/rknand_recovery"
```

* Ejecuta el segundo script.

```shell
adb shell sh /mnt/sdcard/tmp/root.sh
```

El segundo script se encarga de reiniciar el aparato en modo recovery, pasándole como parámetro el instalador de superSu, que esta en el fichero update.zip

```shell
echo 'boot-recovery ' > /cache/recovery/command
echo '--update_package=/mnt/sdcard/tmp/update.zip' >> /cache/recovery/command
reboot recovery
```

## Ejecución del script ##

1.-Connectar el aparato por USB al PC.

2.-Seleccionar la opción "Conectado a PC" en las opciones de USB del dispositivo Android.

3.-Comprobar que tenemos acceso por adb ejecutando `adb devices`.

4.-Descomprimir el [fichero zip]({{ site.data.metadata.lastRoot }}) en el PC.

5.-Ejecutar el fichero root.bat (windows) o root.sh (linux)

Tras dos reinicios deberíamos tener instalado en nuestro sistema la aplicación superSU, para controlar los permisos de root.

Hay que tener en cuenta que el recovery inslalado no parece funcionar con el mando a discancia. Recomiendo instalar [el reocvery de CWM]({{ site.data.metadata.lastCWM }}), una ver que tengamos acesso root.