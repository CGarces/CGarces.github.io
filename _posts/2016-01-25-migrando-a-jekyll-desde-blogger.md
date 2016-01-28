---
layout: post
categories: null
published: true
tags:
- Jekyll
- Github
title: "Migrando a Jekyll desde Blogger"
---


Tenia entre mis cosas pendientes probar  [Jekyll](https://jekyllrb.com/), un generador de sitios estáticos que se integra muy bien con github pages.

También tenia dos blogs en la plataforma Blogger, completamente abandonados. Así que he decidido migrarlos a Jekyll para refrescar mis conocimientos de CSS, probar alguna cosa (fortawesome, google analytics) y ver las posibilidades de github (edición con [prose](http://prose.io/) e integración continua con [codeship](http://codeship.com) )
<!--more-->

La migración desde Blogger ha sido relativamente sencilla hay que seguir los siguientes pasos:

### Instalar jekyll-import.

En este paso no voy a entrar ya que hay muy buena documentación al respecto. Recomiendo la [documentación oficial](https://help.github.com/articles/using-jekyll-with-pages/) de github 

### Instalar jekyll-import.

Bastará con ejecutar: 
{% highlight bash %} gem install jekyll-import{% endhighlight %} 

### Exportar los post de Blogger en XML 

Generar un XML con los post es muy sencillo:

- Selecciona el blog que quieras exportar.
- En el menú de la izquierda, haz clic en Configuración > Otros.
- En el apartado "Herramientas del blog", haz clic en Exportar blog > Descargar blog.

### Exportar los post.

Únicamente hay que indicar la ruta del XML (source), generado en el paso anterior. El resto es opcional

{% highlight bash %} 
    $ ruby -rubygems -e 'require "jekyll-import";
    JekyllImport::Importers::Blogger.run({
      "source"                => "/path/to/blog-MM-DD-YYYY.xml",
      "no-blogger-info"       => false, # No guardar la URL antigua y el id de Blogger
      "replace-internal-link" => false, # Remplezar links internos usando el tag post_url de liquid.
    })'
{% endhighlight %} 

Como resultado tendrás unos ficheros .html con su cabecera YAML

## Limpiando el HTML

El paso siguiente, opcional pero recomendable para facilitar la lectura del post, es pasar el HTML a markdown yo he usado [html2text](https://github.com/aaronsw/html2text), un script python muy sencillo. No respeta la cabecera YAML, pero es fácil agregarlo teniendo en cuenta que mantenemos el fichero HTML original

## Afinando el markdown

El siguiente paso es limpiar un poco el post. Al pasar a .md puede que se haya perdido algún formato particular debido al uso de CSS. En mi caso perdí el resaltado del código, pero github soporta [pygments](http://pygments.org/) por defecto, así que mis post quedaron incluso mejor que los originales de Blogger. En caso de tener muchos post recomiendo modificar el código de html2text para que realice estas modificaciones de forma automática.
