# CI - Continuous Integration

CI "é uma prática de desenvolvimento que visa integrar o código de diversos membros de um time através de um repositório compartilhado. Cada integração é verificada através de builds e testes automatizados".

Ou seja, todas as vezes que estivermos desenvolvendo um software, precisamos garantir que ele funcione e não quebre o repositório central. Portanto um fluxo de CI bem estruturado nos dará mais segurança para entregarmos desta forma.

- Automatiza os processos e garante que o código de todos está funcionando em conjunto;
- Detecta erros antes de eles irem para produção;
- Garante que o build está sendo gerado corretamente.

## Dinâmica de processo

Temos então um repositório central, com vários desenvolvedores realizando *pull request*. Para cada *pull request*, será rodado o processo de CI que irá fazer um *clone* da aplicação, ou seja, ele terá um servidor próprio onde realiza o clone da aplicação, logo após serão baixadas as dependências (npm, pip, composer, etc.) e finalmente serão realizados os testes. E quando todo o fluxo for aprovado será realizado o *merge*.

![CI Process](ci-process.png)

## Algumas boas práticas

- Pipeline (todas as etapadas de processo de integração da aplicação) rápido, pois quanto menos o poder computacional e mais rápido for o build, maior será a economia, pois conseguiremos fazer mais builds simultâneos. Importante destacar algumas das ferramentas de CI cobram por minuto de máquinas utilizadas;
- Ambiente isolado;
- Rodar primeiro os testes mais rápidos;
- Todos do time podem ter acesso aos resultados para que o time fique ciente de onde estão quebrando os testes.

## Ferramentas populares

- Jenkins;
- CircleCI;
- Travis;
- Google Cloud Build;
- Amazon Cloud Build;
- Azure Pipelines;
- GitLab CI;
- Codeship;
- Go CD;
- Team City.

## Iniciando com GCP - Google Cloud Platform

Na nossa parte prática, iremos utilizar o Google Cloud Build da GCP. Porém, o que for abordado aqui poderíamos aplicar em outras ferramentas, obviamente que cada ferramenta possui suas particularidades.

O GCP não é gratuíto, mas normalmente a Google libera cupons de desconto para uso.

É necessário compreender que tudo é separado por projetos no GCP. Portanto vamos criar um novo projeto para realizarmos a nossa prática.

Confira o dashboard do projeto que criamos.

![GCP Dash](gcp-dash.png)

É muito indicado que façamos a instalação do CLI da GCP através [deste link](https://cloud.google.com/sdk).

Vamos então habilitar o Google Cloud Build:

![Google Cloud Build](gcb-active.png)