# Arquitetura de Software - Fundamentos

## O que é arquitetura? - Pilares

### 1. Organização de um sistema

Organização não somente o software em si, mas todo o processo que envolve o software. 

### 2. Componentização

Junção dos componentes que conseguimos fazer um sistema completo - ecossistema. Um componente pode ser reutilizado em diversos sistemas ou processos, evitando retrabalho.

### 3. Relacionamento entre sistemas

Os softwares hoje em dia reodam de forma integrada, e o arquiteto de software entende como os componentes de software se relacionarão entre si, gerando uma cadeia de fluxo de informações.

### 4. Governança

Forma de como vamos documentar todo o processo de arquitetura, forma de como definir os times, forma de como definiremos os bancos de dados, integrações, etc.

### 5. Ambiente

Tratamento de ambientes de produção, testes, desenvolvimento, etc. provendo a definição da padronização destes ambientes antes mesmo de começarmos a desenvolver.

### 6. Projeto

Algo que tem um início, meio e fim. 

### 7. Projeção

Não deve-se pensar no software como ele está neste momento, mas quais as possibilidades que este software vai poder começar a atender o futuro.

### 8. Cultura

O arquiteto de software vai estudar quais são as melhores tecnologias para serem implementadas mediante o desafio de que cada desenvolvedor envolvido vem de um canto e possui uma forma de desenvolver, conhecendo as mais diversas tecnologias.

## Frameworks

Frameworks são ferramentas e métodos que nos ajudam a focar essencialmente no objetivo final. Frameworks nos ajudam a definir um padrão de trabalho.

Quando falamos de arquitetura de software, teremos duas entidades bem importantes:

![Togaf and ISO](togaf-iso.png)

### TOGAF

É um framework conceitual, ou seja, que todo engenheiro e arquiteto de software deveriam ter pelo menos uma destas competências ou definições.

Define os processos de arquitetura. A documentação possui mais que 900 páginas. Mas é importante saber pelo menos o essencial.

A TOGAF setam conceitos e nomenclaturas padronizadas.

Visão geral de tipos de arquiteturas - TOGAF não se limita somente em arquitetura de software:

- negócio;
- sistema de informação;
- tecnologia;
- planos de migração

### ISO / IEC / IEEE 42010 - Systems and software engineering - Architecture description

Lançado em 2011, é bem mais simplificado que o TOGAF, formalizando os fundamentos da área de arquitetura de software.

## Momentos da Arquitetura de Software

### Momento: Tradicional

![Metodologia de Desenvolvimento Waterfall](waterfall.png)

![Aplicação Monoliticas](monoliticas.png)

![Infra On-premise](on-premise.png)

### Momento: Atual

![Metodologia de Desenvolvimento Ágile](agile.png)

![Aplicação Multi-tier - Distribuídos](multi-tier.png)

![Infra - Virtualização](virtualizacao.png)

### Momento: Emergente

![Metodologia de Desenvolvimento DevOps & FullCycle](full-cycle.png)

![Aplicação Microserviços](microservices.png)

![Infra - Containers](container.png)

### Momento: Futuro

![NoOps](no-ops.png)

Não haverá mais necessidade em trabalhar com aqueles processos inteiros de operação para conseguirmos subir as aplicações, não ficar preocupados com servidores, memória, versões, backups. Ou seja, todo o processo de DevOps sairão das nossas mãos e ficarão sendo administradas pelas própias nuvens.

![Aplicação Serverless](serveless.png)

![Infra - Public Cloud](public-cloud.png)