# Análise Jogos Caixa

Aplicação web de **análise estatística da Mega Sena**: importa os resultados
oficiais da Caixa, calcula estatísticas (frequência, atraso, padrões, validação
por qui-quadrado, simulação e backtest) e permite registrar e conferir apostas
por usuário autenticado.

> **Este repositório é a vitrine do projeto.** O código-fonte é privado; aqui
> ficam públicos apenas a ideia, a arquitetura, o modelo de dados e a estrutura
> de pastas — sem as regras de negócio.

## Objetivo

Gerar **estatísticas** sobre os sorteios — e não prever ou descobrir os números
do próximo concurso. Todo sorteio é independente e cada combinação tem a mesma
probabilidade; as análises (frequência, atraso, simulação, backtest e validação)
existem para entender o comportamento dos sorteios, confirmar que as
distribuições seguem o acaso e mostrar que nenhuma regra de escolha de dezenas
aumenta a chance de ganhar. O que muda a probabilidade é apenas a quantidade de
dezenas por combinação (cobertura).

## Propósito de aprendizado

Projeto de estudo para **levar uma aplicação full stack à nuvem**: backend,
frontend, banco, autenticação, deploy e operação. O tema é o pretexto para
exercitar o ciclo completo — modelagem de dados com migrations, API REST em
.NET, SPA em React, login OIDC com Keycloak, nginx + HTTPS numa EC2 da AWS,
serviço no `systemd`, DDNS, backup e segredos em variáveis de ambiente.

Arquitetura, **padrões de projeto** e decisões estão em
[`Docs/ARQUITETURA.md`](Docs/ARQUITETURA.md).

## Uso de IA

O desenvolvimento contou com **apoio de assistentes de IA** para implementação,
documentação e revisão. A condução, porém, foi humana: a análise do problema, o
escopo, as decisões de arquitetura, os critérios de qualidade e a validação do
que foi entregue foram definidos e revisados por mim (Marcelo Dávila). A IA
atuou como ferramenta sob direção, não de forma autônoma.

Além de aprender a levar a aplicação à nuvem, o projeto teve um segundo
objetivo: **validar o uso de IA no desenvolvimento** na prática — quanto ela
acelera, onde erra, quanto exige revisão e como manter responsabilidade sobre o
código final.

## Funcionalidades

- **Importação** dos resultados oficiais, pelos últimos N concursos ou pelo
  histórico completo enviado em planilha `.xlsx`.
- **Frequência** por dezena (01–60), com as mais e menos sorteadas.
- **Atraso** atual por dezena, média histórica e maior atraso registrado.
- **Padrões**: pares/ímpares, soma média e dezenas repetidas entre concursos.
- **Validação**: teste qui-quadrado de uniformidade e distribuições reais
  comparadas às teóricas.
- **Simulação** de combinações de 6 a 15 dezenas, com retrospecto de acertos
  contra todo o histórico.
- **Acertos por quantidade de dezenas**: média empírica de cada tamanho de jogo.
- **Backtest walk-forward**: regras de escolha (mais sorteadas, mais atrasadas,
  simulador) comparadas a um controle puramente aleatório.
- **Base preparada para múltiplas loterias**: dimensão de loteria e vínculos nas
  entidades de concursos e apostas; atualmente, a Mega Sena está cadastrada.
- **Desdobramento**: geração de um grupo de dezenas e de apostas relacionadas,
  com possibilidade de salvar o grupo e consultar suas apostas vinculadas.
- **Autenticação OIDC** (Keycloak) para as rotas do usuário.
- **Minhas Apostas**: registrar apostas manualmente ou salvar combinações da
  simulação ou de um desdobramento, com conferência de acertos contra o histórico
  e agrupamento por concurso-alvo.
- **Doação voluntária via Pix** (modelo break-even), com o QR Code montado no
  backend.

## Stack

| Camada   | Tecnologia                                                |
|----------|-----------------------------------------------------------|
| Backend  | ASP.NET Core Web API (.NET 9) + EF Core + Pomelo (MySQL)  |
| Banco    | MySQL 8                                                   |
| Frontend | React 19 + Vite + TypeScript                              |
| Auth     | Keycloak (OIDC, Authorization Code + PKCE)                |
| Dados    | API oficial da Caixa (dados públicos)                     |

## Arquitetura

```mermaid
flowchart LR
    N[Navegador<br/>React + Vite] -->|HTTPS| G[nginx]
    G -->|/api| B[Backend<br/>ASP.NET Core .NET 9]
    G -->|/realms, /resources| K[Keycloak]
    B -->|EF Core / Pomelo| D[(MySQL 8)]
    B -->|HTTP| C[API oficial da Caixa]
    K --> KP[(Postgres do Keycloak)]
```

Camadas, padrões de projeto, decisões e fluxos em
[`Docs/ARQUITETURA.md`](Docs/ARQUITETURA.md).

## Modelo de dados

```mermaid
classDiagram
    class Loteria {
        +int Id (PK)
        +string Codigo (único)
        +string Nome
        +int DezenaMin
        +int DezenaMax
        +int QtdSorteadas
        +int QtdMinAposta
        +int QtdMaxAposta
        +bool Ativa
    }
    class Concurso {
        +int LoteriaId (PK/FK)
        +int Numero (PK)
        +DateTime DataApuracao
    }
    class ConcursoDezena {
        +int LoteriaId (PK/FK)
        +int ConcursoNumero (PK/FK)
        +int Dezena (PK)
        +int OrdemSorteio
    }
    class Aposta {
        +int Id (PK)
        +string UsuarioSub
        +DateTime DataCriacao (UTC)
        +string? Observacao
        +int LoteriaId (FK)
        +int? ConcursoNumero
        +int? GrupoId (FK opcional)
    }
    class ApostaDezena {
        +int ApostaId (PK/FK)
        +int Dezena (PK)
    }
    class ApostaValidacao {
        +int ApostaId (PK/FK)
        +int ConcursoBase
        +int? AcertosConcursoAlvo
        +string? DezenasAcertadas
        +int UltimoConcurso
        +int AcertosUltimoConcurso
    }
    class GrupoDesdobramento {
        +int Id (PK)
        +string UsuarioSub
        +DateTime DataCriacao (UTC)
        +string? Observacao
        +int LoteriaId (FK)
        +int DezenasPorAposta
        +int? ConcursoNumero
    }
    class GrupoDesdobramentoDezena {
        +int GrupoId (PK/FK)
        +int Dezena (PK)
    }
    class GrupoDesdobramentoValidacao {
        +int GrupoId (PK/FK)
        +int ConcursoBase
        +int? AcertosConcursoAlvo
        +int UltimoConcurso
        +int AcertosUltimoConcurso
    }
    Loteria "1" --> "0..*" Concurso : agrupa
    Loteria "1" --> "0..*" Aposta : classifica
    Loteria "1" --> "0..*" GrupoDesdobramento : classifica
    Concurso "1" --> "1..*" ConcursoDezena : possui
    Aposta "1" --> "1..*" ApostaDezena : possui
    Aposta "1" --> "0..1" ApostaValidacao : validação
    GrupoDesdobramento "1" --> "1..*" GrupoDesdobramentoDezena : possui
    GrupoDesdobramento "1" --> "0..1" GrupoDesdobramentoValidacao : validação
    GrupoDesdobramento "1" --> "0..*" Aposta : origina
```

`Concursos` usa chave composta `(LoteriaId, Numero)`. As tabelas de dezenas usam
chaves compostas que impedem dezenas repetidas dentro do mesmo concurso, aposta
ou grupo. O vínculo de uma aposta a um grupo também protege a associação por
usuário e loteria.

## Endpoints da API

| Método | Rota                                        | Descrição                                                     |
|--------|---------------------------------------------|---------------------------------------------------------------|
| GET    | `/api/concursos`                            | Lista paginada de concursos                                   |
| GET    | `/api/concursos/{numero}`                   | Busca concurso pelo número                                    |
| GET    | `/api/concursos/proximo`                    | Retorna o próximo número de concurso                         |
| POST   | `/api/concursos/importacao`                 | Importa os últimos N concursos da Caixa                        |
| POST   | `/api/concursos/importacao-arquivo`         | Importa o histórico a partir de um `.xlsx` no servidor         |
| POST   | `/api/concursos/importacao-upload`          | Importa o histórico por upload multipart de `.xlsx`            |
| GET    | `/api/estatisticas/frequencia`              | Frequência por dezena (01–60)                                 |
| GET    | `/api/estatisticas/atraso`                  | Atraso atual, média histórica e maior atraso                  |
| GET    | `/api/estatisticas/padroes`                 | Pares/ímpares, soma média e dezenas repetidas                 |
| GET    | `/api/estatisticas/validacao`               | Qui-quadrado de uniformidade e distribuições reais vs. teóricas |
| GET    | `/api/estatisticas/simulacao?quantidade=&dezenas=` | Combinações simuladas + retrospecto                     |
| GET    | `/api/estatisticas/acertos-por-dezenas`     | Média empírica de acertos por tamanho de jogo                 |
| GET    | `/api/estatisticas/backtest`                | Backtest walk-forward contra controle aleatório               |
| GET    | `/api/estatisticas/desdobramento?grupo=&dezenas=&quantidade=` | Gera dados de um desdobramento             |
| GET    | `/api/apostas`                              | Lista as apostas do usuário, com conferência                  |
| POST   | `/api/apostas`                              | Cria uma aposta manual — exige login                           |
| POST   | `/api/apostas/simuladas`                    | Salva uma aposta da simulação ou desdobramento — exige login   |
| PUT    | `/api/apostas/{id}/concurso`                | Altera o concurso-alvo — exige login                           |
| DELETE | `/api/apostas/{id}`                         | Exclui uma aposta do usuário logado                           |
| GET    | `/api/grupos`                               | Lista os grupos do usuário logado — exige login                |
| POST   | `/api/grupos`                               | Cria um grupo de desdobramento — exige login                   |
| DELETE | `/api/grupos/{id}?excluirApostas=`          | Exclui um grupo — exige login                                  |
| GET    | `/api/doacao/pix`                           | BR Code (QR Code Pix) para doação voluntária                   |

As rotas `/api/apostas*` e `/api/grupos*` exigem token OIDC
(`Authorization: Bearer <token>`) e são escopadas pelo identificador do usuário.
As rotas de estatísticas e concursos são públicas.

## Autenticação

O login é delegado a um **Keycloak** (realm `suite-autenticacao`), com fluxo
Authorization Code + PKCE. O frontend guarda o token apenas em memória; o
backend valida o JWT e associa cada aposta ao identificador (`sub`) do usuário.
O Análise Jogos Caixa **não recebe nem armazena senhas**.

## Estrutura

Árvore completa (sem o conteúdo dos arquivos) em
[`Docs/ESTRUTURA.md`](Docs/ESTRUTURA.md). Resumo:

```
AnaliseJogosCaixa/
├── backend/AnaliseJogosCaixa.Api/   # API: Controllers, Model, Data, Services
└── frontend/src/                    # SPA: pages, components, hooks, services
```

O modelo é multi-loteria, mas atualmente só a Mega Sena está cadastrada. A
funcionalidade de desdobramento mantém o grupo como entidade própria e vincula
as apostas geradas a esse grupo.

## Produção

Aplicação disponível em: <https://analisejogoscaixa.ddns.net/>.

> **Aviso:** a aplicação pode não estar disponível no momento em que você tentar
> acessá-la.

Deploy em uma instância EC2 (Amazon Linux 2023): nginx com HTTPS (Let's Encrypt)
servindo o frontend estático e fazendo proxy do backend e do Keycloak; banco
MySQL e Keycloak sem exposição pública de portas. Detalhes em
[`Docs/ARQUITETURA.md`](Docs/ARQUITETURA.md).

## Documentação

- [Arquitetura, padrões de projeto e decisões](Docs/ARQUITETURA.md)
- [UML](Docs/UML.md)
- [Estrutura de pastas](Docs/ESTRUTURA.md)

## Avisos legais

- "Mega Sena" é marca registrada da Caixa Econômica Federal; o projeto usa o nome
  apenas de forma descritiva e educativa, sem afiliação ou endosso.
- Os resultados dos sorteios são dados públicos (Lei 13.756/2018), usados aqui
  para fins educacionais e estatísticos, sem fins comerciais.
- O projeto não prevê resultados nem garante ganhos; participe com
  responsabilidade e apenas se tiver mais de 18 anos.
