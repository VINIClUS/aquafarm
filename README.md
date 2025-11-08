# AquaFarm API

API para ingestão de dados de sensores para o projeto AquaFarm. A aplicação é projetada para receber leituras de sensores de forma assíncrona, garantindo alta performance e escalabilidade.

## Funcionalidades

-   **Endpoint para Ingestão de Dados**: Rota específica para receber leituras de sensores via POST.
-   **Processamento Assíncrono**: Utiliza jobs em background para processar e salvar os dados, evitando gargalos na API.
-   **Estrutura Escalável**: Código organizado com namespaces para facilitar a manutenção e o versionamento futuro da API.
-   **Testes Automatizados**: Suíte de testes com RSpec para garantir a qualidade e a estabilidade do código.

## Tecnologias Utilizadas

-   **Backend**: Ruby on Rails 7
-   **Banco de Dados**: PostgreSQL
-   **Jobs em Background**: backend default do Active Job
-   **Testes**: RSpec

## Pré-requisitos

Antes de começar, garanta que você tenha os seguintes softwares instalados em sua máquina:
-   Ruby (versão 3.1.2 ou superior)
-   Bundler
-   PostgreSQL

## Começando

Siga os passos abaixo para configurar e rodar o projeto localmente.

**1. Clone o repositório:**
```bash
git clone https://github.com/VINIClUS/aquafarm.git
cd aquafarm
```

**2. Instale as dependências:**
```bash
bundle install
```

**3. Configure o banco de dados:**
Crie o arquivo `config/database.yml` a partir do exemplo e configure suas credenciais do PostgreSQL.
```bash
cp config/database.yml.example config/database.yml
```
*Edite `config/database.yml` com os dados do seu banco de dados local.*

**4. Crie e migre o banco de dados:**
```bash
rails db:create
rails db:migrate
```

**5. Inicie a aplicação:**
O projeto utiliza a CLI do Rails para rodar todos os serviços de desenvolvimento (servidor, workers, etc.) de uma só vez. Execute:
```bash
./bin/dev
```
Isso iniciará o servidor Rails, bem como qualquer outro processo definido no seu `Procfile.dev`. Por padrão, a API estará disponível em `http://localhost:3000`.

## Uso da API

A API possui um endpoint principal para a ingestão de leituras de sensores.

### Enviar Leitura de Sensor

-   **Método**: `POST`
-   **URL**: `/ingest/sensor_readings`
-   **Headers**:
    -   `Content-Type: application/json`
-   **Corpo da Requisição (Payload)**:

    ```json
    {
      "pond_id": "pond.id",
      "reading_time": "",
      "metrics": {
        "temp_c": 25.5,
        "ph": 7.1,
        "do_mg_l": 89.2,
        "turbidity_ntu": 4.1,
        "salinity_ppt": 12.1
      }
    }
    ```

#### Exemplo com cURL:

```bash
curl -X POST http://localhost:3000/ingest/sensor_readings \
-H "Content-Type: application/json" \
-d '{"pond_id":pond_id,"reading_time":"","metrics":{"temp_c":29.1,"ph":7.0,"do_mg_l":6.3,"turbidity_ntu":4.1, "salinity_ppt":12.1}}'
```
Uma resposta `202 Accepted` com o corpo vazio indica que os dados foram recebidos com sucesso e agendados para processamento em background.

## Executando os Testes

Para rodar a suíte de testes e garantir que tudo está funcionando como esperado, execute o seguinte comando:

```bash
bundle exec rspec
```

## Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma *issue* para relatar bugs ou sugerir melhorias. Se desejar contribuir com código, por favor, abra um *Pull Request*.

## Licença

Este projeto está licenciado sob a [Licença MIT](https://choosealicense.com/licenses/mit/).