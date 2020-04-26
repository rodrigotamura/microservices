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

### Criando o primeiro *trigger*

Algumas questões que precisamos compreender antes de prosseguir:

- Todas as vezes que formos utilizar o Google Cloud Build - GCB -, vamos ter alguns gatilhos que serão acionados (quando der um *push* no repositório o GCB será acionado).

Vamos reaproveitar o projeto que criamos [aqui](https://github.com/rodrigotamura/microservices/tree/master/Docker/laravel) no módulo de Docker, porém com um Docker compose indicado para o GCB, que seria [esse daqui](../Docker/laravel/docker-compose.cloudbuild.yaml).

As principais modificações seriam remover as variáveis de ambiente pois vamos entender que o arquivo .env entrará em funcionamento, e alterar o *entrypoint*, pois não iremos mais utilizar o Dockerize.

Agora, dentro da pasta `.docker` do projeto, vamos criar um novo arquivo de configuração chamado [cloudbuild.yaml](../Docker/laravel/.docker/cloudbuild.yaml). Este arquivo será lido pelo GCB onde terão todos os passos que devem ser executados.

Quando trabalhamos com GCB teremos duas opções:

1. Configurar para que o GCB leia e execute o Dockerfile da aplicação realizando também o teste de tudo o que está no Dockerfile ou;
2. Que o GCB leia o cloudbuild.yaml que criamos anteriormente, conseguindo fazer testes mais profundos com a pipeline passo-a-passo de tudo o que desejamos testar (**o indicado seria o uso desta opção**).

Abra o [cloudbuild.yaml](../Docker/laravel/.docker/cloudbuild.yaml) e veja cada comando com suas respectivas explicações. Logo após vamos enviar estes arquivos criados para o nosso repositório central.

Acesse o Google Cloud Build, vamos configurar o repositório e criar uma nova **_trigger_** que é um acionador que será executado toda vez que algo acontecer.

![Google Cloud Build trigger](gcb-trigger.png)

Caso esteja utilizando o GitHub, o mesmo solicitará a autenticação e a escolha do repositório a ser configurado o GCB. Após isso, vamos criar um acionador, ou *trigger*:

![Google Cloud Build new trigger](gcb-trigger-new.png)

- Nome: informar um nome para o trigger;
- Evento: vamos selecionar que o gatilho seja acionado quando houver novos *pushes* para o repositório;
- Fonte - Repositório: Selecionar qual repositório;
- Fonte - Ramificação: Qual o branch que será configurado o acionador;
- Configuração da compilação: indica qual o arquivo de compilação será utilizado. Neste caso iremos utilizar a opção "Arquivo de configuração do Cloud Build (yaml ou json)", que irá buscar o arquivo `cloudbuild.yaml` de criamos anteriormente.

Após tudo configurado, vamos executar esta trigger manualmente:

![Google Cloud Build run trigger](gcb-trigger-run.png)

Você notará nos logs que haverão erros de que não está encontrando a imagem do docker-compose no local que indicamos:

![Google Cloud Build run trigger error](gcb-trigger-logs-error.png)

O Docker compose precisa ser instalado para que consigamos trabalhar com ele. No próximo tópico iremos realizar esta instalação.

### Entendendo a instalação do Docker

Vimos que houve um erro no tópico anterior quando tentarmos criar o primeiro passo da pipeline no GCB. Aconteceu que ao instalar o Docker compose através do endereço do Google Cloud Registry que informamos no [cloudbuild.yaml](../Docker/laravel/.docker/cloudbuild.yaml) não foi encontrado nada.

Agora vamos aprender a como criar uma nova imagem do Docker Compose e colocar lá dentro do Container Registry, dentro do Google Cloud.

Toda vez que estamos trabalhando com o Docker Hub, todas as nossas imagens ficam gravadas lá. NEste nosso caso, tudo o que agente for gravar, ficará gravado no Container Registry do GCP, que é **totalmente privado e somente usuários que autorizamos terão acesso**.

A partir deste momento nós precisaremos realizar o *build* da imagem do Docker Compose para colocá-lo dentro do Container Registry.

Portanto, temos que entender dois pontos importantes.

1. Dentro do Container Registry do GCP há um container aberto para todo mundo.E lá dentro tem, por exemplo, o Docker, Git, Go, Dockerize, etc. Então toda vez que quisermos utilizar o Google Cloud Build podemos chamar o endereço **_gcr.io/cloud-builders/Docker_** para, por exemplo, executar o Docker; ou **_gcr.io/cloud-builders/git_** para executar o Git.

2. Porém existirão imagens que não estarão disponíveis, como o Docker Compose, no nosso caso.

Para isso temos que colocar o Docker Compose dentro do nosso Container Registry (**_gcr.io/$PROJECT_ID_** (codeeducation-test)) que não é público.

A ideia é nós termos um Dockerfile, e dentro dele instalarmos o Docker Compose e chamar o *entrypoint* para o Docker Compose. Assim, todas as vezes que a imagem for chamada ela já vai executar o Docker Compose.

Logo após, vamos criar o cloudbuild.yaml e nós vamos **utilizar o Docker do gcr.io/cloud-builders/**, e depois **gerar um _build_ a partir do Dockerfile** e esse Dockerfile irá realizar o *build* do Docker Compose.

Uma vez que tenho o Docker Compose, vamos dar o push da imagem no **_gcr.io/$PROJECT_ID_** (codeeducation-test).

Visão geral da instalação do Dokcer Compose:

![Docker Compose installation on GCP](docker-compose-gcp.png)

O interessante é que isso será feito somente uma vez, podendo ser usado outras vezes.