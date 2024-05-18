# Aplicativo de celular para listar tarefas a serem executadas

O presente aplicativo tem por objetivo permitir que o usuário acompanhe, por meio do celular, uma lista de tarefas a serem executadas pelo mesmo, como ir ao mercado ou limpar a casa. Para cadastrar a tarefa, o usuário informa um título e uma descrição para a mesma. O aplicativo adiciona, automaticamente, a data em que está sendo cadastrada a tarefa e a cidade onde encontra-se o celular. Após cadastrar a tarefa, a mesma pode ser visualizada, alterada ou excluída.

No âmbito técnico, o aplicativo foi construído utilizando a linguagem Flutter. O armazenamento das tarefas é realizado no próprio celular, por meio da biblioteca "sqflite". Já localização do celular é realizada por meio da biblioteca "location" e a identificação da cidade usando a latitude e longitude do celular é feita por meio de API gratuita voltada pela essa finalidade.

As imagens a seguir mostram a aplicação em funcionamento:

1. Image da tela principal, contendo a lista de tarefas
![Imagem 1](lista_tarefas_flutter1.PNG)
