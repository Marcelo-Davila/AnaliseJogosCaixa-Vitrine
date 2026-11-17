# UML

Diagramas do Análise Jogos Caixa (Mermaid). Mostram as entidades, as classes
principais de cada camada e o relacionamento entre elas, sem detalhar a
implementação.

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

O número do concurso é único por loteria (`LoteriaId + Numero`). As chaves
compostas nas tabelas de dezenas impedem repetições dentro do concurso, da aposta
ou do grupo. A associação entre grupo e aposta também é validada por usuário e
loteria.

## Backend

```mermaid
classDiagram
    class ContextoMegaSena {
        +DbSet~Loteria~ Loterias
        +DbSet~Concurso~ Concursos
        +DbSet~ConcursoDezena~ ConcursoDezenas
        +DbSet~Aposta~ Apostas
        +DbSet~ApostaDezena~ ApostaDezenas
        +DbSet~ApostaValidacao~ ApostaValidacoes
        +DbSet~GrupoDesdobramento~ GruposDesdobramento
        +DbSet~GrupoDesdobramentoDezena~ GrupoDesdobramentoDezenas
        +DbSet~GrupoDesdobramentoValidacao~ GrupoDesdobramentoValidacoes
    }
    class ConcursosController {
        +ObterPagina(pagina, tamanho)
        +ObterPorNumero(numero)
        +ObterProximo()
        +Importar(quantidade)
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
        +Desdobramento(grupo, dezenas, quantidade)
    }
    class ApostasController {
        +Listar()
        +Criar(requisicao)
        +CriarSimulada(requisicao)
        +AlterarConcurso(id, requisicao)
        +Excluir(id)
    }
    class GruposController {
        +Listar()
        +Criar(requisicao)
        +Excluir(id, excluirApostas)
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
        +Desdobramento(grupo, dezenas, quantidade)
    }
    class ServicoAposta {
        +Listar(usuarioSub)
        +Criar(usuarioSub, dezenas, observacao, concursoNumero, grupoId)
        +AlterarConcurso(usuarioSub, id, concursoNumero)
        +Excluir(usuarioSub, id)
    }
    class ServicoGrupo {
        +Listar(usuarioSub)
        +Criar(usuarioSub, dezenas, dezenasPorAposta, observacao, concursoNumero)
        +Excluir(usuarioSub, id, excluirApostas)
    }
    class ConferenciaDezenas {
        +Conferir(dezenas, concursoAlvo, concursos)
        +Aplicar(validacao, conferencia, concursoBase)
        +CarregarConcursos(contexto)
    }
    class ServicoDoacao {
        +MontarBrCode(chave)
    }
    ContextoMegaSena <-- ConcursosController : usa
    ContextoMegaSena <-- ServicoEstatistica : usa
    ContextoMegaSena <-- ServicoImportacaoCaixa : usa
    ContextoMegaSena <-- ServicoAposta : usa
    ContextoMegaSena <-- ServicoGrupo : usa
    ConcursosController --> ServicoImportacaoCaixa : usa
    ConcursosController --> ServicoImportacaoExcel : usa
    EstatisticasController --> ServicoEstatistica : usa
    ApostasController --> ServicoAposta : usa
    GruposController --> ServicoGrupo : usa
    ServicoAposta --> ConferenciaDezenas : usa
    ServicoGrupo --> ConferenciaDezenas : usa
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
    class DesdobramentoPage {
        +grupo, dezenasPorAposta, quantidade
        +salvar grupo e apostas
    }
    class ValidacaoPage
    class ApostasPage {
        +apostas por concurso
        +grupos do usuário
    }
    class DoacaoPix
    class AutenticacaoMenu
    class useAutenticacao
    class identidade {
        +chaveDaAposta(dezenas, concurso)
        +chaveDoGrupo(dezenas, porAposta, concurso)
    }
    class Keycloak
    class api {
        +obterConcursos()
        +obterProximoConcurso()
        +importarConcursos()
        +obterFrequencia()
        +obterAtrasos()
        +obterPadroes()
        +obterSimulacao()
        +obterAcertosPorDezenas()
        +obterValidacao()
        +obterDesdobramento()
        +obterApostas()
        +criarAposta()
        +salvarApostaSimulada(grupoId?)
        +alterarConcursoAposta()
        +excluirAposta()
        +obterGrupos()
        +criarGrupo()
        +excluirGrupo(excluirApostas)
    }
    App --> HomePage : renderiza
    App --> DashboardPage : renderiza
    App --> ConcursosPage : renderiza
    App --> FrequenciaPage : renderiza
    App --> AtrasoPage : renderiza
    App --> PadroesPage : renderiza
    App --> SimulacaoPage : renderiza (exige login)
    App --> DesdobramentoPage : renderiza (exige login)
    App --> ValidacaoPage : renderiza
    App --> ApostasPage : renderiza (exige login)
    App --> DoacaoPix : renderiza (rodapé)
    App --> AutenticacaoMenu : renderiza
    App --> useAutenticacao : usa
    SimulacaoPage --> api : usa
    SimulacaoPage --> identidade : evita aposta repetida
    DesdobramentoPage --> api : usa
    DesdobramentoPage --> identidade : evita grupo/aposta repetidos
    ApostasPage --> api : usa
    DashboardPage --> api : usa
    ConcursosPage --> api : usa
    useAutenticacao --> Keycloak : usa OIDC com PKCE
```

## Autenticação e dados do usuário

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
    U->>F: Salvar aposta ou grupo
    F->>A: POST /api/apostas ou /api/grupos (Bearer token)
    A->>K: valida assinatura/emissor do JWT
    K-->>A: token válido
    A->>A: extrai o "sub" do usuário
    A->>D: grava os dados vinculados ao "sub"
    D-->>A: ok
    A-->>F: dados + conferência de acertos
```
