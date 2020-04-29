# Kubernetes

## Introdução

Kubertnetes é um orquestrador, ou gerenciador de containers riquíssimo em recursos.

> Kubernetes é um produto Open Source para automatizar a implantação, o dimensionamento e o gerenciamento de aplicativos em contêiner. (Fonte: https://kubernetes.io/pt)

### De onde veio?

O Kubernetes veio da Google, com um nome inicial de *Borg*, evoluindo para *Omega* e finalmente evoluido para Kubernetes. Portanto, não é a toa que os melhores Clods Providers para Kubernetes é a própria Google.

### Pontos importantes

- Kubernetes é disponibilizado através de um conjunto de APIs, ou seja, tudo o que fizermos no Kubernetes, no final das contas, são feitos via endpoints de API (criação de deployment, serviços, PODs, etc.);
- Porém, ao invés de ficarmos usando esta APIs podemos usar um CLI: **kubectl**;
- Tudo é baseado em estado, onde teremos vários objetos e cada objeto tem um estado, e baseado no estado deste objeto o Kubernetes toma determinadas ações;
- O Kubernetes trabalha através de **clusters**, que é um conjunto de máquinas que juntas possui um poder computacional para realizar diversos tipos de tarefas. Especificamente no caso do Kubernetes, possui um cluster chamado **_master_** que controla os processos que os outros nós irão fazer. O *master* possui alguns serviços disponíveis:
    - Kube-apiserver;
    - Kube-controller-manager;
    - Kube-scheduler;
- Outros nós que não são *master*:
    - Kubelet;
    - Kubeproxy.

### Dinâmica "Superficial"

Vamos fazer uma análise BEM SUPERFICIAL de como o Kubertnete funciona.

![Overview Kubernetes](kubernetes-intro.png)

(o quadrado cinza representa um *cluster*)

O Kubernetes possui o conhecimento da capacidade computacional de cada *node*, o que faz com que ele consiga provisionar os recursos necessários para as tarefas.

![PODs](pod.png)

Normalmente é um POD por container e são raras as exceções de um POD conter mais de um container rodando.

### Deployment

É um outro tipo de "objeto" de Kubernetes com o objetivo de provisionar os PODs. Para esta provisão, o Kubertnetes precisa saber quantas réplicas destes PODs serão disponibilizados. Então temos o termo **replica sets**, onde setamos quantas réplicas queremos de cada *set* de POD. Mas normalmente agente consegue setar estas réplicas sets dentro da mesma descrição do próprio *deployment*.

No esquema abaixo, temos uma aplicação *backend* (B) e *frontend* (F), onde numa primeira etapa o *deployment* provisionou dentro de um nó (quadrado cinza) 3 réplicas para o B e 2 réplicas para o F. Num segundo momento houve uma necessidade de se escalar o F para 3 réplicas. E num terceiro e último momento foi necessário escalar o B para 4 réplicas, porém não houveram mais provisionamento do *deployment* pois não existem mais recursos computacionais. Então este 4º POD vai ficar pendente até que surja mais nós ou que este nós tenha mais recursos.

![Deployment](deployment.png)

Mas vamos imaginar que foi adicionado mais um nó neste *cluster* e o mesmo está vazio. Então o Kubernetes, através do *deployment* vai adicionar o POD que estava pendente.

![Deployment Nodes](deployment-nodes.png)

Vamos supor que um destes nós ficou fora do ar. O Kubernetes vai provisionar os PODs que estão fora do ar no nós qu eestá funcionando, porém alguns PODs vão ficar de fora pois não caberão todos, ficando assim aguardando novos nós ou aumento dos recursos no atual nó.

## Entendendo Services

Services é a interface de comunicação entre o ambiente externo e os nossos PODs. Afinal, se tivermos vários PODs como saberei qual acessar? Então os *Services* nos ajudam nesta demanda.

> *Services* é uma forma de agregar um conjunto de PODs para então implementar políticas de visibilidade. Através das políticas de visibilidade adotada iremos expor os nossos PODs.

Existem três tipos principais de services, aos quais veremos a seguir.

### Services - ClusterIP

É o *service* padrão quando criado no Kubernetes. 

![ClusterIP](services-clusterip.png)

Imaginamos que temos um tráfego da rede entrando, então temos um *proxy* que sabe em qual *service* mandar, e logo temos um *service* que aponta para os PODs.

Partimos da regra que os PODs se comunicam entre si e não possui um acesso direto ao mundo externo. Então teremos um IP virtual gerada pelo *cluster* e tudo que roda ali dentro, no final das contas, acontece de forma interna.

### Services - NodePort

Diferente do ClusterIP, este tipo de *service* não trabalha com *proxy*.

![NodePort](services-nodeport.png)

Então temos uma carga externa de tráfego vindo, então nós temos os nós (node da máquina 1, node da máquina 2, etc.) e uma porta específica. Esta carga de tráfego cairá em uma determinada porta e, independente de qual porta cair, será encaminhado para um *service* que apontará para os PODs.

Então não temos um *proxy* para rotear, mas sim várias portas que são atribuídas para cada serviço. Se em algum momento cair na porta, por exemplo 3001, não importa qual node que cair este tráfego, automaticamente o Kubernetes sabe que ele tem que redirecionar para um determinado serviço.

### Service - LoadBalancer

A ideia principal é export um IP externo e a carga do tráfego cairá neste *LoadBalancer*, que fará toda a distriuição de carga, inclusive para saber em qual nó ele encaminhará o acesso.

No ClusterIP não temos acesso externo, somente para dentro do *cluster*. Se estivermos com o NodePort na mesma rede e mandarmos um tráfego para qualquer um dos nodes naquela porta, o mesmo receberá e o LoadBalancer garantirá isso do lado de fora.

### Selectors

Mas **como saberemos que determinados PODs pertence a determinado _service_?**

Para isso temos os **_Selectors_**, que será definido no *service* para fazer um filtro de verificação para saber quais PODs ele vai colocar dentro daquele serviço.

![Services - Selectors](services-selectors.png)

Assim temos uma ideia de como podemos selecionar os PODs dentro de um serviço através de *selectors* que definiremos as propriedades e que podem ser várias. Vamos supor que temos *backends* em NOdeJS na versão X com a propriedade Z. Podemos colocar todas estas informações no *seletor*. Quando formos criar os services conseguimos fazer esses filtros e ele vai buscar todos os PODs com estas características para gerar o *service* deixando tudo disponível.

## Minikube

Com o Minikube podemos criar uma máquina virtual com o *Singlenode Kubernetes* rodando dentro dele na nossa máquina, para que possamos fazer a prática em Kubernetes. Salienta-se que os recursos são bem limitados, não terá disponível o *LoadBalancer*, etc. Mas é totalmente viável testarmos as operações básicas.

### Instalação

Acesse [este link](https://kubernetes.io/docs/tasks/tools/install-minikube/) para iniciar a instalação do Minikube.

> 👉 Como máquina virtual estaremos utilizando o **VirtualBox**.

Lembrando que também precisamos [instalar o **kubectl**](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux).

Para inicializar o Minikube temos que executar o comando `minikube start` (na primeira execução poderá demorar um pouco).

> O **kubectl** é um *client* do Kubernetes para se comunicar com algum *cluster* do Kubernetes. Nele podemos configurar arquivos de configuração que setam cada *namespace* para estabelecermos a comunicação com determinado *cluster*. Podemos então configurar um ambiente para que o *kubectl* se comunique com o *cluster* 1, ou o *cluster 2*, ou o *cluster* na Amazon, no GCP, no Minikube, etc. E nestes arquivos de configuração temos um certificado que garante que o kubectl tem autorização para acessar determinados *clusters* de Kubertnetes.

Após inicializado o Minikube, note que aparecerá a mensagem que *kubectl is now configured to use "minikube"*, ou seja, todos os comandos de `kubectl` que executarmos está configurado para o Minikube.

Para listarmos os *services* do nosso Minikube, vamos executar: `kubectl get svc` que retornará o seguinte:

```
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   9m25s
```

Retornou um elemento chamado **kubernetes**, do tipo **ClusterIP** (só possui comunicação interna por dentro do *cluster*), note que não tem IP externo, mas somente o interno.

## Criando primeiro POD

Neste tópico iremos aberdar como se cria um POD, porém, no dia a dia não vamos sair e ir criando PODs, mas sim vamos criar um *Deployment* e ele será responsável por criar os PODs.

Vamos criar um arquivo chamado [pod.yaml](pod.yaml). Abra-o para visualizar os detalhamentos.

Após configurado o arquivo acima, vamos rodar o seguinte comando:

`kubectl apply -f pod.yaml`

- `apply`: para aplicar este arquivo, aplicando sempre as novas alterações caso houver;
- `-f <nome-arquivo>`: declarando que vamos indicar um arquivo.

Caso dê tudo certo aparecerá a mensagem `pod/pod-exemplo created` 👍

Executando o comando `kubectl get pods` listarão os PODs e retornará o seguinte:

```
NAME          READY   STATUS    RESTARTS   AGE
pod-exemplo   1/1     Running   0          101s
```

O comando `kubectl logs pod-exemplo` retornará possíveis erros. Se não retornar algo significa que o POD subiu sem problemas 😉.

Mas, **_como faremos para acessar este container do NGINX que criamos dentro deste POD?_**

Lembra que, como foi abordado ontem, todo o tráfego que precisa acessar é necessário ter um *service*, possuindo os três tipos - ClusterIP, LoadPort e LoadBBalancer. No próximo tópico vamos matar este POD recém criado, vamos criar um *Deployment*, e através deste vamos criar um novo POD e depois vamos criar um *Service* para expor este *Deployment* onde tem os PODs rodando para poder acessar via browser o serviço do NGINX.

## Trabalhando com *Deployments*

Não é recomendado criar PODs como no tópico anterior, pois só foi para questões didáticas.

Aqui vamos criar um *Deployment* que pega um conjunto de PODs (vamos definir isso na parte de réplicas), qual a imagem que ele vai utilizar e quando formos *subir* o *deployment* os PODs serão criados automaticamente.

Vamos criar o *Deployment* de duas formas. A primeira forma é via linha de comando, pois tudo que agente escreve no arquivo YAML podemos executar via linha de comando. Obviamente que na prática não convém optar por isso. Mas o recomendado é a segunda forma, onde utilizaremos um arquivo declarativo YAML.

### Deployment utilizando a linha de comando

Execute inicialmente o comando `kubectl create deployment hello-nginx --image=nginx:1.17-alpine`, onde: 

- `hello-nginx` seria o nome do *deployment*;
- `--image=<nome-imagem>` indica a imagem que será utilizada

Ao executar o comando acima, se der tudo certo, aparecerá a seguinte mensagem:

`deployment.apps/hello-nginx created`

Para listar os *deployments* vamos digitar `kubectl get deployments` que retornará o seguinte:

```
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
hello-nginx   1/1     1            1           82s
```
(a coluna `READY` indica que existe 1 POD de 1 rodando)

Perceba que ao executarmos `kubectl get pods` serão listados todos os PODs que temos:

```bash
NAME                           READY   STATUS    RESTARTS   AGE
hello-nginx-6485484cdf-2ztwg   1/1     Running   0          2m20s
pod-exemplo                    1/1     Running   0          29m
```

O POD `hello-nginx-6485484cdf-2ztwg` foi criado pelo *deployment*.

Perceba que um *deployment* tem um *replicaSet* e este pode escolher quantos PODs ele quer ter disponível.

**Agora vamos criar um _SERVICE_** e a partir dele vamos conseguir acessar o POD que está dentro deste *deployment*.

> Lembrando que estamos fazendo via linha de comando. Mais adiante vamos implementar tudo isso via arquivo declarativo.

Criando o *service* para acesso ao POD:

`kubectl expose deployment hello-nginx --type=LoadBalancer --port=80`

- `expose`: comando para expor algo;
- `deployment <nome-deployment>`: indicando o que queremos expor, neste caso seria o *deployment*;
- `--type=<service-type>`: LoadBalancer / LoadPort / ClusterIP. O Minikube não possui a opção LoadBalancer, mas mais adiante vamos entrar em mais detalhes.
- `--port=<num-porta>`: em qual porta vamos expor para acesso externo.

Caso dê tudo certo será retornado o seguinte:

`service/hello-nginx exposed`

Ao executar o comando para listar os *services* via `kubectl get services`, será retornado o seguinte:

```
NAME          TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
hello-nginx   LoadBalancer   10.107.76.245   <pending>     80:31052/TCP   3m23s
kubernetes    ClusterIP      10.96.0.1       <none>        443/TCP        16h
```

Note que foi criado o `hello-nginx`, o IP `10.107.76.245` indica o IP do cluster, o `EXTERNAL-IP` está como pendente pois não vai gerar. Ali na coluna `PORT(S)` está declarando que ao acessar a porta 31052 o *service* redirecionará para a porta 80 do POD.

O seguinte comando do Minikube realizará o acesso para o POD:

`minikube service hello-nginx`

Você notará que o navegador será aberto com o endereço para acesso ao POD e retornando o seguinte:

```
|-----------|-------------|-------------|-------------------------|
| NAMESPACE |    NAME     | TARGET PORT |           URL           |
|-----------|-------------|-------------|-------------------------|
| default   | hello-nginx |          80 | http://172.17.0.2:31052 |
|-----------|-------------|-------------|-------------------------|
🎉  Opening service default/hello-nginx in default browser...
```

Perceba que o IP aberto no navegador não é o mesmo que o indicado no *cluster IP*. Na verdado o IP indicado no navegador foi gerado pelo próprio Minikube.

### Deployment via arquivo declarativo

Esta é a forma normal de sere criado um *deployment*.

Vamos criar um arquivo chamado [deployment.yaml](deployment.yaml).

Antes de colocar no ar o *Deployment* configurado via YAML, vamos "matar" todos os outros *Deployments* criados anteriormente via comando:

`kubectl delete deployments --all`

Agora vamos executar o seguinte comando para colocarmos no ar o *Deployment* criado: `kubectl apply -f deployment.yaml` então retornará uma resposta notificando que o *deployment* foi criado.

