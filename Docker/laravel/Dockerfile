FROM php:7-fpm-alpine3.9

# Instalando o bash, mysql
# Logo apos adicionando a extensao para o PHP se comunicar com o MySQL
RUN apk add bash mysql-client \
    && docker-php-ext-install pdo pdo_mysql

### Instalação Dockerize
RUN apk add --no-cache openssl

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz
### Fim declaração Dockerize

# Geralmente a porta 9000 esát disponível para o PHP FPM
EXPOSE 8000

# Os comandos RUN abaixo serao executados de dentro do /var/www
WORKDIR /var/www

# Removendo todo o conteúdo padrão
RUN rm -rf /var/www/html

# copiando todo o conteudo do Laravel para a pasta publica do PHPFPM
COPY . /var/www

# Instalando o Composer
RUN curl -s https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN whoami && \
    groups $(whoami)


# Iniciando o Laravel
RUN composer install && \
            cp .env.example .env && \
            php artisan key:generate && \
            php artisan config:cache

# Corrigindo um problema de permissao que ocorre
RUN chown -R www-data:www-data * && \
    php artisan key:generate

# Criando um link simbolico da pasta /var/www/public (do Laravel)
# para /var/www/html (que é a pasta pública do PHP FPM).
# Ou seja, toda vez que estiverem acessando a pasta html
# na realidade estao acessando a pasta public, tipo um redirecionamento
RUN ln -s public html

# O comando abaixo matera o servidor rodando
ENTRYPOINT ["php-fpm"]
