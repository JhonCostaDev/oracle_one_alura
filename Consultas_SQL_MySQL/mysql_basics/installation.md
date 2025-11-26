# instalando o MySQL e Workbench




##Instalação para Windows

Para isso, acesse o seu navegador e pesquise por “MySQL Downloads” e acesse o seguinte material.

Ao final desta página acessada, você encontrará a opção “MySQL Community (GPL) Downloads”. Para acessá-la diretamente, clique aqui.

Nesta página de downloads, você pode optar pela opção “MySQL Installer for Windows” ou acessar diretamente através deste [link](https://dev.mysql.com/downloads/).

Sugerimos que escolha a primeira opção “Windows (x86, 32-bit), MSI Installer”, com tamanho de armazenamento menor. Esta opção nos dará a possibilidade de escolher quais arquivos do pacote desejamos baixar e não utilizará mais armazenamento do que o necessário para nossa utilização. Clique em “download” na lateral direita desta opção, como mostrado na imagem abaixo:

![Print da janela de opções de instalação do MySQL para Windows com os textos “Windows (x86, 32-bit), MSI Installer” e “2.1M” grifados em vermelho, assim como o botão de download](http://cdn3.gnarususercontent.com.br/3679-conhecendo-mysql/Imagens%20das%20atividades/img%201%20preparando%20o%20ambiente%20aula%201.png)



Logo em seguida, você será direcionado para a uma página sugerindo que você faça o login ou crie uma conta Oracle, mas para a instalação não será necessário, clique na opção ”Não, obrigado, basta iniciar meu download” localizada logo abaixo das sugestões para acesso e criação de conta.

![Print da tela com a sugestão de fazer login ou criar um conta Oracle, com a opção “Não, obrigado, basta iniciar meu download”,  grifada em vermelho](http://cdn3.gnarususercontent.com.br/3679-conhecendo-mysql/Imagens%20das%20atividades/img%202%20preparando%20o%20ambiente%20aula%201.png)



Em seguida, clique na opção “Download now” e o download da ferramenta começará.

Agora, vá em seus downloads e clique duas vezes no instalador da ferramenta “mysql-installer-web-community-8.0.36.0.

Em seguida, uma nova janela será aberta perguntando se você permite que alterações sejam feitas pela ferramenta. Clique em “Sim”.

Agora, a janela de instalação do MySQL aparecerá. Vamos escolher qual o tipo de instalação que queremos realizar. Dentro da aba ”Choosing a Setup Type”, selecione a última opção de nome ** “Full”**, essa opção contém todos os itens da ferramenta que precisaremos utilizar, depois clique em next na parte inferior direita.

![Print da tela de instalação do MySQL com as opções ”Choosing a Setup Type”, “Full” e next grifadas em vermelho](http://cdn3.gnarususercontent.com.br/3679-conhecendo-mysql/Imagens%20das%20atividades/img%203%20preparando%20o%20ambiente%20aula%201.png)



Agora a ferramenta irá confirmar o nome de todos os itens que serão instalados, então clique em execute na parte inferior direita da janela.

Aparecerão todos os itens contidos nessa opção que estão prontos para download, então clique em next e depois em execute na parte inferior direita da janela.

Depois, passaremos para a opção de Product Configuration da janela de instalação, onde aparecerá o nome da versão da ferramenta que será instalada, então clique em next.

Agora a ferramenta irá confirmar as informações de conectividade na opção Type and Networking mantenha as informações padrão e apenas clique em next.

Em seguida, teremos a tela de Authentication Method para escolher o método de autenticação, mantenha no padrão recomendado e apenas clique em next.

Depois, chegara a hora de criar sua senha de usuário, após escolher uma senha clique em next.

Nas próximas telas com as configurações do Windows Service, Server file permissions e Apply Configuration mantenha como está e apenas clique em next e por fim em execute.

Depois clique em finish.

Aparecerá a opção “Connect to server**, então coloque sua senha escolhida no campo password e clique em check, o programa confirmará se a conexão foi bem sucedida e após a confirmação clique em next e depois em execute e finish.

Clique novamente em next e finish.

E pronto! A janela de boas vindas da interface do MySQL se abrirá e já está tudo certo para começarmos a utilizar a ferramenta no Windows.

## Instalação para Mac Os
O MySQL pode ser instalado no macOs através do Homebrew. Caso você precise instalar rode o comando abaixo no terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Para a instalação do MySQL execute o comando abaixo:

    brew install mysql
    
## Instalação no Linux

TODO...