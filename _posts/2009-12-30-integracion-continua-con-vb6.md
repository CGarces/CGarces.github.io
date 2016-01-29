---
layout: post
title: Integración continua con VB6
author: Carlos Garcés
tags: 
- Integración Continua
- pop2owa
modified_time: '2016-01-29T10:53:04.080-07:00'
---

Trabajar con VB6 es como tener un coche antiguo, puede que los nuevos sean mejores, pero seguro que tienes alguna razón para no cambiarlo.

De la misma forma que con un coche antiguo puedes disfrutar de modernas autopistas o ponerle un MP3, en tus proyectos de VB6 también también puedes usar herramientas creados para plataformas mas modernas como .NET.

En este caso, voy a explicar como simplificar el proceso de publicación de las versiones de un proyecto usando las herramientas de integración continua.

Cada vez que quería publicar una versión de [pop2owa](http://www.pop2owa.com) debía realizar manualmente las siguientes operaciones.

- Cambiar la versión del proyecto de VB6.
- Compilar.
- Probar el ejecutable.
- Cambiar la versión del instalador.
- Generar el instalador.
- Generar un zip con los fuentes.
- Generar la documentación.
- Generar el log de cambios.
- Subir por FTP el log y la documentación.
- Subir a Sourceforge el instalador y los fuentes.
- Publicar la versión en Sourceforge.

Tenia que revisar manualmente todo y mas de una vez tuve que repetir alguno de los pasos. Algunos, como generar la documentación y el log de cambios, a veces ni lo hacia.

<!-- leer mas -->

###Publicando un proyecto en VB6 con NAnt

Para realizar estas tareas opté por [NAnt](nant.sourceforge.net/), después de haber visto funcionar [Ant](http://ant.apache.org/) en el trabajo. También use tareas de [NAntContrib](http://nantcontrib.sourceforge.net/)

El script reproduce la mayoría de los pasos detallados arriba, aunque algunos no pueden ser automatizados.

###Cambiar la versión del proyecto de vb6

Esta operación la hago a mano, aunque podría intentar automatizarla con la información del repositorio de código fuente (SVN en mi caso)


###Generar el log de cambios

Este paso también es manual, aunque me planteo que el proceso genere unos ficheros intermedios con los comentarios del SVN para ayudarme a escribir el log.

###Compilar

Para compilar un proyecto de VB6 en NANT se puede usar la tarea vb6 de NAntContrib

```html
<target name="compile" description="Compile pop2owa">
    <vb6 project="pop2owa.vbp"/>
</target>
```

Cuando el ejecutable esta compilado, uso la función `fileversioninfo` para obtener el numero de versión y usarlo en el resto de script (versionado de ficheros e instalador).

```html
<target name="version" description="Get version number from last compiled executable">
	<property name="out.exeversion" value="${fileversioninfo::get-file-version(fileversioninfo::get-version-info('pop2owa.exe'))}"/>
</target>
```

###Probar el ejecutable

Para probar el ejecutable he elegido [SimplyVBUnit](http://simplyvbunit.sourceforge.net/) ya que no creo que sea posible usar NUnit de una forma tan sencilla.
El uso de simplyvbunit me llevaría otro post entero así que no voy a entrar en detalles.

###Generar el instalador y cambiar el número de versión

Para el instalador uso un script de [NSIS](http://NSIS.sourceforge.net/) con una variable pasada como parámetro como numero de versión (opción /D de `makensis`). Así evito tener que crear una nueva versión del instalador cada vez.

NAnt no tiene una tarea para NSIS, pero tampoco lo veo necesario ya que es suficiente con la tarea exec para ejecutar makensis por linea de comandos y readregistry para evitar usar rutas fijas.

```html
<target name="BuildInstaller" depends="compile, version" description="Build NSIS Installer">
    <readregistry property="dependencies.nsis" key="SOFTWARE\NSIS\" hive="LocalMachine" />
    <exec program="${dependencies.nsis}\makensis.exe">
        <arg value="/XOutFile ${out.exefile}"/>
        <arg value="/DVERSION=v${out.version}"/>
        <arg value="/v1"/>
        <arg value="pop2owa.nsi"/>
    </exec>	
</target>    
```

###Generar un zip con los fuentes

NAntContrib tiene una tarea para generar ficheros Zip, únicamente es necesario especificarle un fileset. El nombre del fichero se crea versionado.

```html
<property name="out.zipfile" value="${out.path}\pop2owa_v${out.version}_src.zip"/>
<property name="out.exefile" value="${out.path}\pop2owa_v${out.version}.exe"/>
...
<target name="zipsource" description="Create one ZIP file with pop2owa sources" depends="version">
    <zip zipfile="${out.zipfile}" verbose="true" ziplevel="9">
        <fileset>
            <include name="Be Mail.ico"/>
            <include name="clsConfig.cls"/>
            <include name="clsOWA.cls"/>
            ...
            <include name="sample_config.xml"/>
            <include name="sample_config.include"/>
        </fileset>
    </zip>
</target>
```

###Generar la documentación

La documentación se genera automáticamente con VBDOX, aunque tuve que modificarlo ligeramente para que pudiera ejecutarse por linea de comandos.

```html
<target name="BuildDoc" description="Build VBDOX documentation">
    <exec program="${dependencies.vbdox}\VBDOX.exe">
        <arg value="pop2owa.vbp"/>
    </exec>	
</target>
```    

El [resultado final](http://www.pop2owa.com/VBDOX/pop2owa.html) es similar a otras herramientas como NDoc.

###Subir por FTP el log y la documentación

NAnt no tiene tarea para operaciones por FTP ni en el core ni en NAntContrib, pero usando google no me fue difícil encontrar una [tarea de FTP](http://www.spinthemoose.com/~ftptask/).

```html
<target name="loadexternaltasks" description="Load NANT tasks">
    <loadtasks assembly="C:\Program Files\NAnt\bin\ftptask.dll" />
    <connection id="pop2owa" server="pop2owa.com" username="${ftp.user}" password="${ftp.password}"/>
</target>
<target name="uploadchangelog" depends="loadexternaltasks"  description="Build all files and upload it to FTP">
    <ftp connection="pop2owa"> 
        <put type="ascii" localdir="${out.BaseDir}\html\en" remotedir="public_html/en/">
            <include name="Change_Log.html" />
        </put>
        <put type="ascii" localdir="${out.BaseDir}\html\es" remotedir="public_html/es/">
            <include name="Change_Log.html" />
        </put>
    </ftp>
</target>

<target name="uploaddoc" depends="loadexternaltasks"  description="Build all files and upload it to FTP">
    <ftp connection="pop2owa"> 
        <put type="bin" localdir="${out.BaseDir}\doc" remotedir="public_html/VBDOX/" update="false">
            <include name="*.gif" />
        </put>
        <put type="ascii" localdir="${out.BaseDir}\doc" remotedir="public_html/VBDOX/">
            <include name="*.html" />
            <include name="*.css" />
        </put>
    </ftp>
</target>
```

###Subir a Sourceforge el instalador y los fuentes

Para subir los ficheros a SourceForge hay varios métodos, pero yo he optado por SCP. Aunque NAntContrib cuenta con una tarea scp, no he sabido usarla correctamente, así que lanzé pscp.exe por linea de comandos.

```html
<property name="scp.addr" value="pop2owa@frs.sourceforge.net:uploads" />
<property name="scp.program" value="pscp.exe" />
...
<target name="deployOnSourceForge"  depends="version"  description="Build all files and upload it">
    <echo message="Uploading ${out.zipfile}..." />
    <exec program="${scp.program}" commandline="-pw ${scp.password} ${out.zipfile} ${scp.user},${scp.addr}" />
    <echo message="Uploading ${out.exefile}..." />
    <exec program="${scp.program}" commandline="-pw ${scp.password} ${out.exefile} ${scp.user},${scp.addr}" />
</target>		
```

###Publicar la versión en Sourceforge

Es otra de las tareas que no puedo automatizar ya que depende de la visibilidad que da SourceForce a sus procesos.


###Conclusión

Como se puede ver, las herramientas como NAnt, MSBuild o Ant no se limitan a compilar un proyecto, pueden usarse para automatizar multitud de tareas, siendo una alternativa muy interesante a los complejos archivos batch que aun a dia de hoy se siguen usando en multitud de proyectos.

Inicialmente NAnt esta orientado a desarrollos .NET pero se puede usar en otros ámbitos y aunque herramientas como NUnit y NDoc no se puedan usar, hay alternativas validas para Visual Basic 6.

Después de casi dos años usando este tipo de herramientas no me imagino realizando este tipo de operaciones de forma manual.



