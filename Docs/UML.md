# UML

Diagramas do Análise Jogos Caixa (Mermaid). Mostram as entidades, as classes
principais de cada camada e o relacionamento entre elas, sem detalhar a
implementação.

## Modelo de dados

```mermaid
classDiagram
    class Concurso {
        +int Numero (PK)
        +DateTime DataApuracao
    }
    class ConcursoDezena {
        +int Id (PK)
        +int ConcursoNumero (FK)
        +int Dezena (01-60)
        +int OrdemSorteio (1-6)
    }
    class Aposta {
        +int Id (PK)
        +string UsuarioSub (sub do Keycloak)
        +DateTime DataCriacao
        +string Observacao
    }
    class ApostaDezena {
        +int Id (PK)
        +int ApostaId (FK)
        +int Dezena (01-60)
        +int Ordem
    }
    Concurso "1" --> "1..*" ConcursoDezena : possui
    Aposta "1" --> "1..*" ApostaDezena : possui
```

## Backend

```mermaid
classDiagram
    class ContextoMegaSena {
        +DbSet~Concurso~ Concursos
        +DbSet~ConcursoDezena~ ConcursoDezenas
        +DbSet~Aposta~ Apostas
        +DbSet~ApostaDezena~ ApostaDezenas
    }
    class ConcursosController {
        +ObterPagina(pagina, tamanho)
        +ObterPorNumero(numero)
        +Importar(quantidade)
        +ImportarArquivo(requisicao)
        +ImportarUpload(arquivo)
    }
    class EstatisticasController {
        +Frequencia()
        +Atraso()
        +Padroes()
        +Validacao()
        +Simulacao()
        +AcertosPorDezenas()
        +Backtest()
    }
    class ApostasController {
        +Listar()
        +Criar(requisicao)
        +CriarSimulada(requisicao)
        +Excluir(id)
    }
    class DoacaoController {
        +ObterPix()
    }
    class ServicoImportacaoCaixa {
        +Importar(quantidade)
        -ObterNumeroUltimoConcurso()
    }
    class ServicoImportacaoExcel {
        +Importar(caminho)
        +ImportarStream(stream, nomeArquivo, ct)
    }
    class ServicoEstatistica {
        +Frequencia()
        +Atraso()
        +Padroes()
        +Validacao()
        +Simulacao()
        +AcertosPorDezenas()
        +Backtest()
    }
    class ServicoAposta {
        +Listar(usuarioSub)
        +Criar(usuarioSub, dezenas, observacao)
        +Excluir(usuarioSub, id)
        -Conferir(dezenas, concursos)
    }
    class ServicoDoacao {
        +MontarBrCode(chave)
    }
    ContextoMegaSena <-- ConcursosController : usa
    ContextoMegaSena <-- ServicoEstatistica : usa
    ContextoMegaSena <-- ServicoImportacaoCaixa : usa
    ContextoMegaSena <-- ServicoAposta : usa
    ConcursosController --> ServicoImportacaoCaixa : usa
    ConcursosController --> ServicoImportacaoExcel : usa
    EstatisticasController --> ServicoEstatistica : usa
    ApostasController --> ServicoAposta : usa
    DoacaoController --> ServicoDoacao : usa
```

## Frontend

```mermaid
classDiagram
    class App {
        +pagina: Pagina
    }
    class HomePage
    class DashboardPage {
        +frequencia, atraso, padroes
    }
    class ConcursosPage {
        +importar, paginacao
    }
    class FrequenciaPage
    class AtrasoPage
    class PadroesPage
    class SimulacaoPage
    class ValidacaoPage
    class ApostasPage
    class DoacaoPix
    class AutenticacaoMenu
    class useAutenticacao
    class Keycloak
    class api {
        +obterConcursos()
        +importarConcursos()
        +obterFrequencia()
        +obterAtrasos()
        +obterPadroes()
        +obterSimulacao()
        +obterAcertosPorDezenas()
        +obterValidacao()
        +obterApostas()
        +criarAposta()
        +salvarApostaSimulada()
        +excluirAposta()
    }
    App --> HomePage : renderiza
    App --> DashboardPage : renderiza
    App --> ConcursosPage : renderiza
    App --> FrequenciaPage : renderiza
    App --> AtrasoPage : renderiza
    App --> PadroesPage : renderiza
    App --> SimulacaoPage : renderiza
    App --> ValidacaoPage : renderiza
    App --> ApostasPage : renderiza
    App --> DoacaoPix : renderiza (rodapé)
    App --> AutenticacaoMenu : renderiza
    App --> useAutenticacao : usa
    SimulacaoPage --> api : usa (salvar aposta)
    ApostasPage --> api : usa
    DashboardPage --> api : usa
    ConcursosPage --> api : usa
    useAutenticacao --> Keycloak : usa OIDC com PKCE
```

## Autenticação e aposta

```mermaid
sequenceDiagram
    participant U as Usuário
    participant F as Frontend
    participant K as Keycloak
    participant A as Backend
    participant D as MySQL

    U->>F: Entrar
    F->>K: Authorization Code + PKCE
    K-->>F: token de acesso (em memória)
    U->>F: Salvar aposta
    F->>A: POST /api/apostas (Bearer token)
    A->>K: valida assinatura/emissor do JWT
    K-->>A: token válido
    A->>A: extrai o "sub" do usuário
    A->>D: grava a aposta vinculada ao "sub"
    D-->>A: ok
    A-->>F: aposta + conferência de acertos
```
