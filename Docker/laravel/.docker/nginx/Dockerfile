FROM nginx:1.15.0-alpine

# removendo configuracao padrao para
RUN rm /etc/nginx/conf.d/default.conf

# agora vamos copiar um novo arquivo de configuracao
# para podermos rodar o PHP FPH
# Este arquivo vai estar dentro da pasta .docker/nginx
COPY ./nginx.conf /etc/nginx/conf.d