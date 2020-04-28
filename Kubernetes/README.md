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