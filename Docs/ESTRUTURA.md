# Estrutura do projeto

Árvore de pastas e arquivos gerada a partir do repositório de código (privado).
Mostra a organização do projeto sem expor o conteúdo dos arquivos.

Gerado em 17/11/2026 12:35 por `scripts/gerar-estrutura.ps1`.

```
AnaliseJogosCaixa/
├── backend/
│   └── AnaliseJogosCaixa.Api/
│       ├── Controllers/
│       │   ├── ApostasController.cs
│       │   ├── ConcursosController.cs
│       │   ├── DoacaoController.cs
│       │   ├── EstatisticasController.cs
│       │   └── GruposController.cs
│       ├── Data/
│       │   └── ContextoMegaSena.cs
│       ├── Migrations/
│       │   ├── 20260815183243_Inicial.cs
│       │   ├── 20260815183243_Inicial.Designer.cs
│       │   ├── 20260830164516_ControleApostas.cs
│       │   ├── 20260830164516_ControleApostas.Designer.cs
│       │   ├── 20261005231840_ConcursoDaAposta.cs
│       │   ├── 20261005231840_ConcursoDaAposta.Designer.cs
│       │   ├── 20261005233135_ValidacaoPersistidaAposta.cs
│       │   ├── 20261005233135_ValidacaoPersistidaAposta.Designer.cs
│       │   ├── 20261006002400_MultiLoteria.cs
│       │   ├── 20261006002400_MultiLoteria.Designer.cs
│       │   ├── 20261016012524_GrupoDesdobramento.cs
│       │   ├── 20261016012524_GrupoDesdobramento.Designer.cs
│       │   └── ContextoMegaSenaModelSnapshot.cs
│       ├── Model/
│       │   ├── Dto/
│       │   │   ├── AcertosPorDezenas.cs
│       │   │   ├── AlterarConcursoRequest.cs
│       │   │   ├── ApostaResposta.cs
│       │   │   ├── AtrasoDezena.cs
│       │   │   ├── ConcursoResposta.cs
│       │   │   ├── ConferenciaAposta.cs
│       │   │   ├── CriarApostaRequest.cs
│       │   │   ├── FrequenciaDezena.cs
│       │   │   ├── GrupoResposta.cs
│       │   │   ├── ImportacaoArquivoRequest.cs
│       │   │   ├── ImportacaoRequest.cs
│       │   │   ├── JogoSimulado.cs
│       │   │   ├── PaginaConcursos.cs
│       │   │   ├── RespostaAcertosPorDezenas.cs
│       │   │   ├── RespostaBacktest.cs
│       │   │   ├── RespostaCaixa.cs
│       │   │   ├── RespostaDesdobramento.cs
│       │   │   ├── RespostaDoacao.cs
│       │   │   ├── RespostaFrequencia.cs
│       │   │   ├── RespostaPadroes.cs
│       │   │   ├── RespostaSimulacao.cs
│       │   │   ├── RespostaValidacao.cs
│       │   │   ├── ResultadoEstrategia.cs
│       │   │   └── RetrospectoJogo.cs
│       │   ├── Aposta.cs
│       │   ├── ApostaDezena.cs
│       │   ├── ApostaValidacao.cs
│       │   ├── Concurso.cs
│       │   ├── ConcursoDezena.cs
│       │   ├── GrupoDesdobramento.cs
│       │   ├── GrupoDesdobramentoDezena.cs
│       │   ├── GrupoDesdobramentoValidacao.cs
│       │   ├── IValidacaoDezenas.cs
│       │   └── Loteria.cs
│       ├── Properties/
│       │   └── launchSettings.json
│       ├── Services/
│       │   ├── ConferenciaDezenas.cs
│       │   ├── ServicoAposta.cs
│       │   ├── ServicoDoacao.cs
│       │   ├── ServicoEstatistica.cs
│       │   ├── ServicoGrupo.cs
│       │   ├── ServicoImportacaoCaixa.cs
│       │   ├── ServicoImportacaoExcel.cs
│       │   └── ServicoSincronizacaoEc2.cs
│       ├── AnaliseJogosCaixa.Api.csproj
│       ├── AnaliseJogosCaixa.Api.http
│       ├── appsettings.Development.json
│       ├── appsettings.json
│       ├── Program.cs
│       └── WeatherForecast.cs
├── Docs/
│   ├── AUTENTICACAO.md
│   ├── DEPLOY.md
│   ├── PLANO_CONTROLE_APOSTAS.md
│   ├── PROXIMOS_PASSOS.md
│   └── SIMULACAO.md
├── frontend/
│   ├── public/
│   │   ├── favicon.svg
│   │   ├── icons.svg
│   │   └── silent-check-sso.html
│   ├── src/
│   │   ├── assets/
│   │   │   ├── hero.png
│   │   │   ├── react.svg
│   │   │   └── vite.svg
│   │   ├── components/
│   │   │   ├── AutenticacaoMenu.tsx
│   │   │   └── DoacaoPix.tsx
│   │   ├── hooks/
│   │   │   └── useAutenticacao.ts
│   │   ├── pages/
│   │   │   ├── ApostasPage.tsx
│   │   │   ├── AtrasoPage.tsx
│   │   │   ├── ConcursosPage.tsx
│   │   │   ├── DashboardPage.tsx
│   │   │   ├── DesdobramentoPage.tsx
│   │   │   ├── FrequenciaPage.tsx
│   │   │   ├── HomePage.tsx
│   │   │   ├── PadroesPage.tsx
│   │   │   ├── SimulacaoPage.tsx
│   │   │   └── ValidacaoPage.tsx
│   │   ├── services/
│   │   │   ├── api.ts
│   │   │   └── autenticacao.ts
│   │   ├── utils/
│   │   │   └── identidade.ts
│   │   ├── App.css
│   │   ├── App.tsx
│   │   ├── index.css
│   │   ├── main.tsx
│   │   └── types.ts
│   ├── .gitignore
│   ├── .oxlintrc.json
│   ├── index.html
│   ├── package.json
│   ├── package-lock.json
│   ├── README.md
│   ├── tsconfig.app.json
│   ├── tsconfig.json
│   ├── tsconfig.node.json
│   └── vite.config.ts
├── .gitignore
├── iniciar.bat
├── iniciar.ps1
├── publicar.bat
├── publicar.ps1
└── README.md
```
