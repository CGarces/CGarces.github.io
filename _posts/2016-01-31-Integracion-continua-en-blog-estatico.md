---
layout: post
categories: null
published: true
tags:
- Jekyll
- Github
- CodeShip
- Integración Continua
title: "Integración continua en un Blog estático"
image:
  url: /public/images/CodeShip.png
  width: 1056
  height: 843

---

Seguramente un Blog estático como este no sea el mejor ejemplo para evangelizar acerca de las ventajas de la integración continua, pero me ha parecido una buena forma de ponerme al día con estas opciones gratuitas que se integran con Github.

En el [post anterior]({% post_url 2016-01-27-Integracion-continua-con-codeship %}) asocie mi repositorio Git a [codeship](http://codeship.com), para poder ver errores en el proceso de build antes de enviar mis cambios a la rama _main_.

Esto es muy útil pero se quedaba corto así que decidí añadir validaciones adicionales.

<!-- leer mas -->


##HTML5Validator

[Este validador HTML](https://github.com/svenkreiss/html5validator) se asegurara que el código generado cumple con los requerimientos del estándar HTML 5.

El ejecutable requiere Java 8 así que es necesario especificarlo en la sección `Setup Commands` de codeship.

```bash
jdk_switcher use oraclejdk8
pip install html5validator
```

Para validar el codigo del directorio `_site` (el directorio usado por Jekyll para generar el HTML) sera necesario añadir la siguiente linea al apartado `configure test pipelines`

```bash
html5validator --root _site/
```

##HTML-proofer

[html-proofer](https://github.com/gjtorikian/html-proofer) valida el HTML, revisa las imágenes verificando el atributo alt y chequea todos los links de la aplicación.

para usarlo es necesario añadirlo al fichero `Gemfile`

```bash
gem 'html-proofer'
```

De esta forma se instalara automáticamente cuando codeship ejecute `bundle install` como parte del proceso de setup

htmlproof tiene unas cuantas opciones por linea de comandos, ejecuta `htmlproof --help` para verlas todas.

Esta es la sentencia que estoy usando actualmente para verificar mi blog.

```bash
htmlproof ./_site --check-html --check-favicon --only-4xx --href-ignore "/cgarces\.github\.io/"
```

- `./_site` es el directorio donde Jekyll genera el HTML
- `--check-html` valida el HTML aunque teóricamente no es necesario ya que ha sido validado en el paso anterior por html5validator
- `--check-favicon` verifica que todas las paginas tengan un icono asignado
- `--only-4xx` cuando verifica un enlace ignora los errores que no sean de tipo 4xx (para evitar que el build falle por ejemplo con un 302)
- `--href-ignore` Ignora los links que coinciden con una expresión regular. Esto lo uso para eliminar los errores al verificar la url canónica de un articulo que aun no ha subido. Si no esta subido al blog, la ruta canónica (que es absoluta) fallaría.

## Configuración final del proyecto

Con las nuevas validaciones la configuración queda de la siguiente manera.

###Setup Commands

```batch
rvm use 2.2.0 --install
bundle install
bundle update
export RAILS_ENV=test
jdk_switcher use oraclejdk8
pip install html5validator
```

###Test pipelines

```batch
bundle exec jekyll build
html5validator --root _site/
htmlproof ./_site --check-html --check-favicon --only-4xx --href-ignore "/cgarces\.github\.io/"
```

Ahora cada vez que realicemos un commit _en cualquier branch_ se lanzara un build el CodeShip que verificata el build de jekyll, el HTML y todos los enlaces de la pagina.

![Ejemplo Codeship builds](/public/images/CodeShip.png)

Como se puede ver en la imagen hay un build erróneo, desde la propia pagina de CodeShip se puede ver detalle del error. 

```batch
WARNING:html5validator.validator:"file:/home/rof/src/github.com/CGarces/CGarces.github.io/_site/tags/index.html":151.2-151.50: error: Bad value "#Integracin Continua" for attribute "href" on element "a": Illegal character in fragment: space is not allowed.
"file:/home/rof/src/github.com/CGarces/CGarces.github.io/_site/tags/index.html":313.5-313.35: error: Bad value "#Integracin Continua" for attribute "id" on element "h3": An ID must not contain whitespace.
"file:/home/rof/src/github.com/CGarces/CGarces.github.io/_site/tags/index.html":314.5-314.35: error: Bad value "Integracin Continua" for attribute "name" on element "a": An ID must not contain whitespace.
"file:/home/rof/src/github.com/CGarces/CGarces.github.io/_site/2016/01/27/Integracion-continua-con-codeship/index.html":211.3-211.57: error: Bad value "/tags/#Integracin Continua" for attribute "href" on element "a": Illegal character in fragment: space is not allowed.
"file:/home/rof/src/github.com/CGarces/CGarces.github.io/_site/2009/12/30/integracion-continua-con-vb6/index.html":329.3-329.57: error: Bad value "/tags/#Integracin Continua" for attribute "href" on element "a": Illegal character in fragment: space is not allowed.
```

En este caso por ejemplo falla porque que el tag elegido para el articulo (Integración Continua) contenía un espacio y la plantilla no estaba preparada para esa situación.

