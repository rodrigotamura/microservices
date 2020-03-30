FROM php:7.3.6-fpm-alpine3.9

# Geralmente a porta 9000 esát disponível para o PHP FPM
EXPOSE 9000

# Os comandos RUN abaixo serao executados de dentro do /var/www
WORKDIR /var/www

# Removendo todo o conteúdo padrão
RUN rm -rf /var/www/html

# copiando todo o conteudo do Laravel para a pasta publica do PHPFPM
COPY . /var/www

# Criando um link simbolico da pasta /var/www/public (do Laravel)
# para /var/www/html (que é a pasta pública do PHP FPM).
# Ou seja, toda vez que estiverem acessando a pasta html
# na realidade estao acessando a pasta public, tipo um redirecionamento
RUN ln -s public html

# O comando abaixo matera o servidor rodando
ENTRYPOINT ["php-fpm"]
