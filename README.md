# Análise de Dados - eCommerce
Este projeto consiste em análise exploratória, resposta de perguntas e desenvolvimento de um BI utilizando um dataset fictício de um eCommerce. O objetivo é responder as perguntas de negócio referentes à Prazos, Custos, Performance de Vendedores, Clientes e Pagamentos.

Como apoio neste projeto utilizei uma ferramenta de IA, o ChatGPT. Fiz uma breve análise das bases de dados, desenvolvi um prompt e solicitei que ele gerasse perguntas de negócio se colocando em um cargo de Gestor/Gerente e eu como um Analista de Dados. Com isso, ele gerou perguntas relevantes com base no dataset e eu já com a experiência que tenho trabalhando com dados adaptei o que foi necessário.

## 1. Dataset e Projeto

1.1 Fonte do dataset:
* [Ecommerce Order & Supply Chain Dataset](https://www.kaggle.com/datasets/bytadit/ecommerce-order-dataset)

1.2 Ferramentas Utilizadas:
* SQL Server Management Studio;
* Miro;
* Microsoft Excel;
* Microsoft Word;
* Power Query;
* PowerBI;
* Figma.

1.3 Estrutura do Projeto
* Pré análise dos dados dispostos em cada base e desenvolvimento de um diagrama para auxiliar na modelagem e entendimento dos dados. Veja o diagrama [aqui](https://github.com/user-attachments/assets/2983ae11-912d-48b6-a829-3cb60fb75969)!
* Simulando um cenário corporativo em que exista um banco de dados, importei todos os arquivos baixados do Kaggle para o SSMS, realizei alguns tratamentos em SQL e após isso as queries para responder as perguntas de negócio.
* Após isso, conectei o banco de dados ao PowerBI para desenvolver as visualizações e, conforme o dashboard ia sendo montado, algumas alterações foram feitas diretamente no Power Query via Linguagem M.
* Para cálculos no PowerBI foi utilizado DAX e Linguagem M.

1.4 Análise e Visualização:
* As análises inicialmente foram feitas diretamente no SSMS a fim de responder as perguntas inciais do Gestor (IA) e entender a composição dos dados. Foram indentificados também alguns Outliers e isso foi destacado no relatório que foi gerado para o Gestor (IA), o relatório está disponível mais abaixo.
* Desenvolvimento de gráficos interativos para auxiliar nas análises e a responder às perguntas de negócio. Como sugestão do Gestor (IA), foi desenvolvido um dashboard via PowerBI para gerar gráficos dinâmicos.
* Exploração dos dados com foco em insights que auxiliem a identificar pontos críticos e em tomadas de decisões.
* Layout desenvolvido via ferramenta Figma.

## 2. Perguntas de Negócio

2.1 Pedidos e Tempo de Entrega:
* Qual é a diferença média entre a data estimada de entrega e a data real de entrega dos pedidos?
* Qual é a porcentagem de pedidos entregues antes, no prazo e após a data estimada?

2.2 Performance de Vendedores:
* Quais vendedores possuem a maior taxa de pedidos cancelados ou devolvidos?
* Quais vendedores têm a melhor taxa de cumprimento de prazos de entrega?

2.3 Comportamento de Compra dos Clientes:
* Qual é a distribuição geográfica dos clientes em termos de volume de pedidos e valor gasto?
  
2.4 Produtos e Categorias:
* Quais categorias de produtos geram mais receita e quais têm a maior taxa de cancelamento?

2.5 Análise de Pagamentos:
* Qual é o método de pagamento mais utilizado e qual traz maior receita?
* Como está distribuído o número de parcelas escolhidas pelos clientes para os pagamentos a prazo?

## 3. Conclusões com base nas Perguntas Iniciais:

* Você pode verificar o relatório gerado em Word (.docx) clicando no link: [Relatório.docx](https://github.com/user-attachments/files/16805803/Relatorio.docx)


## 4. Dashboard

* Além de simplesmente responder as perguntas, o Gestor (IA) solicitou o desenvolvimento de um dashboard com algumas visualizações que ele gostaria de ter:

4.1 Visão Geral dos Pedidos:

* Gráficos que mostrem o status dos pedidos, tempo médio de entrega, e um resumo de pedidos atrasados versus entregues no prazo.

4.2 Performance dos Vendedores:

* Gráficos de barras comparando a performance dos vendedores em termos de prazos de entrega e taxas de cancelamento.

4.3 Análise de Clientes:

* Mapas de calor ou gráficos geográficos mostrando a distribuição de clientes e o volume de pedidos por região.
* Análise de correlação entre métodos de pagamento e valores dos pedidos.

4.4 Produtos e Categorias:

* Gráficos de pizza ou barras mostrando a receita por categoria e a taxa de devolução por categoria.
* Gráficos de dispersão correlacionando as dimensões/peso dos produtos com os custos de envio.

4.5 Detalhamento dos Pagamentos:

* Gráficos que mostrem a distribuição de métodos de pagamento e a receita correspondente.

## 4.6 Visualização do Dashboard

* No dashboard, desenvolvi outros gráficos além dos solicitados, expandindo assim a quantidade de análises, possibilidades de insights e tomadas rápidas de decisão analisando os gráficos dinamicamente.
* Como não é possível visualizar um arquivo do PowerBI aqui pelo GitHub, acesse clicando [aqui](https://encurtador.com.br/IySV1).

