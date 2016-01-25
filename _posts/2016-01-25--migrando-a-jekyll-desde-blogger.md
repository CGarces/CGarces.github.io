---
excerpt_separator: "<!--more-->"
layout: post
categories: null
image: ""
published: false
title: " Migrando a Jekyll desde Blogger"
---


Tenia entre mis cosas pendientes probar  [Jekyll](https://jekyllrb.com/) un generador de sitios estaticos que se integra muy bien con github pages.

Tambien tenia dos blogs en la plataforma Blogger, completamente abandonados, asi que he decidido migrarlos a Jekyll para referescar mis conocimientos de CSS, probar alguna cosa (fortawesome, google analytics) y ver las posibilidates de github (edicion con [prose](http://prose.io/) e integracion continua con [codeship](http://codeship.com) )

La migracion desde Blogger ha sido relativamente sencilla ay que seguir los siguientes pasos:

### Instalar jekyll-import.

En este paso no voy a entrar ya que hay muy buena documentacion al respecto. Recomiento la [documentacion oficial](https://help.github.com/articles/using-jekyll-with-pages/) de github 

### Instalar jekyll-import.

Bastara con ejecutar `gem install jekyll-import`

### Exportar los post de Blogger en XML 

Generar un xml con los post es muy sencillo:

- Selecciona el blog que quieras exportar.
- En el menú de la izquierda, haz clic en Configuración > Otros.
- En el apartado "Herramientas del blog", haz clic en Exportar blog > Descargar blog.

### Exportar los post.

Unicaménte hay que indicar la ruta del XML (source), generado en el paso anterior. El resto es opcional

    $ ruby -rubygems -e 'require "jekyll-import";
    JekyllImport::Importers::Blogger.run({
      "source"                => "/path/to/blog-MM-DD-YYYY.xml",
      "no-blogger-info"       => false, # No guardar la URL antigua y el id de Blogger
      "replace-internal-link" => false, # Remplezar links internos usando el tag post_url de liquid.
    })'

Como resultado tendrás unos ficheros .html con su cabecera YAML

## Limpiando el HTML

El paso siguiente, opcional pero recomendable para facilitar la lectura del post, es pasar el html a markdown yo he usado [html2text](https://github.com/aaronsw/html2text), un script python muy sencillo. No respeta la cabecera YAML, pero es facil arregarlo teniendo en cuenta que mantenemos el fichero html original

## Afinando el markdown

El siguiente paso es limpiar un poco el post. Al pasar a .md puede que se haya perdido alfun formato particular debido al uso de CSS. En mi caso perdí el resaltado del código, pero github soporta [pygments](http://pygments.org/) por defecto asi que mis post quedaron incluso mejor que los originales de Blogger. En caso de tener muchos post recomiendo modificar el codigo de html2text para que realice estas modificaciones de forma automatica.





