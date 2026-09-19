# Estrutura do projeto

Árvore de pastas e arquivos gerada a partir do repositório de código (privado).
Mostra a organização do projeto sem expor o conteúdo dos arquivos.

Gerado em 18/09/2026 22:04 por `scripts/gerar-estrutura.ps1`.

```
AnaliseJogosCaixa/
├── backend/
│   └── AnaliseJogosCaixa.Api/
│       ├── Controllers/
│       │   ├── ApostasController.cs
│       │   ├── ConcursosController.cs
│       │   ├── DoacaoController.cs
│       │   └── EstatisticasController.cs
│       ├── Data/
│       │   └── ContextoMegaSena.cs
│       ├── Migrations/
│       │   ├── 20260815183243_Inicial.cs
│       │   ├── 20260815183243_Inicial.Designer.cs
│       │   ├── 20260830164516_ControleApostas.cs
│       │   ├── 20260830164516_ControleApostas.Designer.cs
│       │   └── ContextoMegaSenaModelSnapshot.cs
│       ├── Model/
│       │   ├── Dto/
│       │   │   ├── AcertosPorDezenas.cs
│       │   │   ├── ApostaResposta.cs
│       │   │   ├── AtrasoDezena.cs
│       │   │   ├── ConcursoResposta.cs
│       │   │   ├── ConferenciaAposta.cs
│       │   │   ├── CriarApostaRequest.cs
│       │   │   ├── FrequenciaDezena.cs
│       │   │   ├── ImportacaoArquivoRequest.cs
│       │   │   ├── ImportacaoRequest.cs
│       │   │   ├── JogoSimulado.cs
│       │   │   ├── PaginaConcursos.cs
│       │   │   ├── RespostaAcertosPorDezenas.cs
│       │   │   ├── RespostaBacktest.cs
│       │   │   ├── RespostaCaixa.cs
│       │   │   ├── RespostaDoacao.cs
│       │   │   ├── RespostaFrequencia.cs
│       │   │   ├── RespostaPadroes.cs
│       │   │   ├── RespostaSimulacao.cs
│       │   │   ├── RespostaValidacao.cs
│       │   │   ├── ResultadoEstrategia.cs
│       │   │   └── RetrospectoJogo.cs
│       │   ├── Aposta.cs
│       │   ├── ApostaDezena.cs
│       │   ├── Concurso.cs
│       │   └── ConcursoDezena.cs
│       ├── Properties/
│       │   └── launchSettings.json
│       ├── Services/
│       │   ├── ServicoAposta.cs
│       │   ├── ServicoDoacao.cs
│       │   ├── ServicoEstatistica.cs
│       │   ├── ServicoImportacaoCaixa.cs
│       │   └── ServicoImportacaoExcel.cs
│       ├── AnaliseJogosCaixa.Api.csproj
│       ├── AnaliseJogosCaixa.Api.http
│       ├── appsettings.Development.json
│       ├── appsettings.json
│       ├── Program.cs
│       └── WeatherForecast.cs
├── Docs/
│   ├── AUTENTICACAO.md
│   ├── PLANO_CONTROLE_APOSTAS.md
│   └── PROXIMOS_PASSOS.md
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
│   │   │   ├── FrequenciaPage.tsx
│   │   │   ├── HomePage.tsx
│   │   │   ├── PadroesPage.tsx
│   │   │   ├── SimulacaoPage.tsx
│   │   │   └── ValidacaoPage.tsx
│   │   ├── services/
│   │   │   ├── api.ts
│   │   │   └── autenticacao.ts
│   │   ├── App.css
│   │   ├── App.tsx
│   │   ├── index.css
│   │   ├── main.tsx
│   │   └── types.ts
│   ├── .env.example
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
├── AGENTS.md
├── iniciar.ps1
└── README.md
```
