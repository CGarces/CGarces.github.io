---
layout: post
categories: null
published: true
tags:
- Jekyll
- Github
- CodeShip
- Integración Continua
title: "Integración continua con CodeShip"
---

Sigo trabajando en este Blog como escusa para poner al día mis conocimientos y probar cosas nuevas.

Ahora le toca el turno a la integración continua.

Ya había trabajado en el pasado con Cruise Control, Jenkins y Sonar, pero nunca había probado las soluciones que hay en la nube, muchas de ellas gratuitas.

He elegido [codeship](http://codeship.com) por que es el producto usado por uno de los blog en Jekyll que he usado como referencia y tenia un [manual muy detallado](http://www.robertiagar.com/2014/08/25/how-i-manage-my-blog/) de como hacer la integración.

<!-- leer mas -->

### Configuración del proyecto

La configuración es muy fácil solo hay que seguir unos sencillos pasos.

- Elegir el origen de código fuente (Github o Bitbucket) 
- Seleccionar la plantilla de `ruby` para el tipo de proyecto

```batch
rvm use 2.2.0 --install
bundle install
```

A la configuración estándar hay que añadir una linea mas para que se instalen las dependencias de nuestro proyecto. 

```batch
rvm use 2.2.0 --install
bundle install
bundle update
```

Para que `bundle install bundle update` funcione es necesario tener un fichero gemfile en el repositorio

```batch
source 'https://rubygems.org'
gem 'github-pages'
```

Ten en cuenta que con este fichero gemfile no solo se instala Jekyll. `github-pages` contiene todas las dependencias y nos asegura que el build sera el mismo que realiza GitHub de forma automática.

En __Test Commands__ únicamente es necesario invocar al build de Jekyll

```batch
bundle exec jekyll build
```

Ahora cada vez que realicemos un commit _en cualquier branch_ se lanzara un build el CodeShip

Esto es especialmente útil si cada cambio del blog (como un nuevo post) lo hacemos en una nueva rama, como se ve en la siguiente imagen.

![Ejemplo pull request github](/public/images/branch_github.png)

Trabajar asi nos permite saber si hay algún error en el código _antes_ de aceptar el pull request y que pase a formar parte de la rama main.

Todos los build de nuestro proyecto los podemos ver en una pantalla similar a esta.

![Ejemplo Codeship builds](/public/images/CodeShip.png)

Como se puede ver en la imagen hay un build erróneo, pero eso sera parte de mi siguiente post, _añadir validación HTML_
