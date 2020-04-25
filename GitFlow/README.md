# GitFlow

O Gitflow é uma metodologia que ajuda no versionamento de software em equipes. Aqui iremos abordar a dinâmica de trabalho do Gitflow.

> O Gitflow é um processo que visa utilizar o Git como ferramenta para gerenciar a criação de novas *features*, correções, *bugs* e *releases*.

Vamos a um exemplo de FALTA de padronização de um projeto no Git:

- Nome de branches: `git checkout -b formulario_de_registro` ou `git checkout -b bug_01`;
- *Push* direto na master: `git push origin master`;

Exemplo de forma correta de se trabalhar:

- Lançando nova funcionalidade: `git checkout -b feature/registro`;
- Correção de um *bug*: `git checkout -b hotfix/registro`;
- Dar um *push* direto no *develop* (ambiente de homologação): `git push origin develop`;
- E o do *develop* dar um *merge* no *master*: `git checkout master && git merge develop`.

Portanto no Gitflow temos as seguintes premissas: **Padrão, Legibilidade e Processo**.

## Como funciona o Gitflow

Teremos duas *branches* principais:

![Master e Develop](git-branches.png)

O MASTER sempre vai ter o código-fonte que está em produção. E o DEVELOP vai ter o código-fonte em desenvolvimento incluindo novas funcionalidades.

A regra de ouro é: 👉 **NUNCA COMITAR DIRETAMENTE NO MASTER** 👈

### Branch Develop

A *branch develop* sempre estará atrelada a outras três *branches*:
- Features;
- Releases;
- Hotfixes;

Estas três *branches* sempre farão o *merge* na *branch develop*.

![Develop](develop.png)

#### Branch Feature

Criada a partir do último *commit* da *branch develop*, aqui serão criadas as novas funcionalidades.

![Develop -> Features](develop-features.png)

Logo após de desenvolver a nova funcionalidade:

![Develop -> Features Done](develop-features-done.png)

#### Branch Release

Criada a partir do último *commit* da *branch develop*, aqui serão lançadas a nova versão da aplicação (de NOVAS funcionalidades, não de *bugs*).

Vamos supor que a *branch develop* já possui várias funcionalidades novas, desenvolvidas por vários colaboradores. A partir disso iremos gerar a *branch release* com a versão incrementada da atual, e que por sua vez, irá ser finalmente enviada para a *branch master*.

![Develop -> Releases](develop-releases.png)

#### Branch Hotfix

*Branch* responsável pelas correções de *bugs* dentro da aplicação.

Como a *branch master* deve receber a correção IMEDIATAMENTE, o *merge* da *branch hotfix* deve ser dado diretamente ao *master* e ao *develop*.

![Hotfix](hotfix.png)

### Extensão Gitflow

Existe uma opção que pode ser aplicada em um projeto para facilitar o trabalho no Git utilizando a metodologia Gitflow. Salienta-se que não é algo essencial para se trabalhar com a metodologia, sendo que é totalmente viável a aplicação do Gitflow sem o uso desta extensão.

Temos que primeiramente instalar a extensão do Git-flow na máquina. No caso do Ubuntu 18.04: `sudo apt-get install -y git-flow`

Somente inicialize o Git no seu projeto desta forma: `git flow init`.

Abaixo vamos exemplificar o trabalho com o Git-flow:

Para a **Feature**:
- Início da nova funcionalidade: `git flow feature start feature/register`;
- Encerra desevnolvimento de nova funcionalidade: `git flow feature finish feature/register`.

Para a **Release**:
- Criando a *branch release*: `git flow release start 1.0.0`;
- Fechando a *branch release* e realizando *merge* na *master*: `git flow release finish '1.0.0'`.

Para o *Hotfix*:
- Criando a *branch hotfix*: `git flow hotfix start hotfix/recurso`;
- Após finalizar o desenvolvimento da correção: `git flow hotfix finish hotfix/recurso`. Esse comanda já executará o *merge* tanto no *master* como no *develop*.