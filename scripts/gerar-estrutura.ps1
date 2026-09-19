<#
.SYNOPSIS
    Gera Docs/ESTRUTURA.md com a árvore de pastas do projeto de código.

.DESCRIPTION
    Percorre o projeto privado (pasta irmã AnaliseJogosCaixa) e escreve apenas
    os nomes de pastas e arquivos — nunca o conteúdo. Diretórios gerados
    (bin, obj, node_modules, dist) e arquivos sensíveis (.env, *.user, *.log)
    ficam de fora.

.PARAMETER Projeto
    Caminho do projeto de código. Padrão: ..\..\AnaliseJogosCaixa

.PARAMETER Saida
    Caminho do arquivo gerado. Padrão: ..\Docs\ESTRUTURA.md

.EXAMPLE
    .\gerar-estrutura.ps1
#>
[CmdletBinding()]
param(
    [string]$Projeto,
    [string]$Saida
)

$ErrorActionPreference = 'Stop'

$raizScript = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $Projeto) { $Projeto = Join-Path $raizScript '..\..\AnaliseJogosCaixa' }
if (-not $Saida) { $Saida = Join-Path $raizScript '..\Docs\ESTRUTURA.md' }

$pastasIgnoradas = @('.git', '.idea', '.vs', 'bin', 'obj', 'node_modules', 'dist')
$arquivosIgnorados = @('.env', 'Thumbs.db', 'Desktop.ini', '.DS_Store')
$padroesIgnorados = @('*.user', '*.log', '*.log.*')

function Test-Ignorado {
    param([System.IO.FileSystemInfo]$Item)

    if ($Item.PSIsContainer) { return $pastasIgnoradas -contains $Item.Name }
    if ($arquivosIgnorados -contains $Item.Name) { return $true }
    foreach ($padrao in $padroesIgnorados) {
        if ($Item.Name -like $padrao) { return $true }
    }
    return $false
}

function Add-Arvore {
    param(
        [string]$Caminho,
        [string]$Prefixo,
        [System.Collections.Generic.List[string]]$Linhas
    )

    $itens = Get-ChildItem -LiteralPath $Caminho -Force |
        Where-Object { -not (Test-Ignorado $_) } |
        Sort-Object @{ Expression = { -not $_.PSIsContainer } }, Name

    for ($i = 0; $i -lt $itens.Count; $i++) {
        $item = $itens[$i]
        $ultimo = ($i -eq $itens.Count - 1)
        $conector = if ($ultimo) { '└── ' } else { '├── ' }
        $nome = if ($item.PSIsContainer) { "$($item.Name)/" } else { $item.Name }
        [void]$Linhas.Add("$Prefixo$conector$nome")

        if ($item.PSIsContainer) {
            $proximoPrefixo = $Prefixo + $(if ($ultimo) { '    ' } else { '│   ' })
            Add-Arvore -Caminho $item.FullName -Prefixo $proximoPrefixo -Linhas $Linhas
        }
    }
}

if (-not (Test-Path -LiteralPath $Projeto)) {
    throw "Projeto não encontrado: $Projeto"
}

$linhas = [System.Collections.Generic.List[string]]::new()
$raiz = (Resolve-Path -LiteralPath $Projeto).Path
[void]$linhas.Add((Split-Path $raiz -Leaf) + '/')
Add-Arvore -Caminho $raiz -Prefixo '' -Linhas $linhas

$data = Get-Date -Format 'dd/MM/yyyy HH:mm'
$cerca = '```'
$conteudo = @(
    '# Estrutura do projeto',
    '',
    'Árvore de pastas e arquivos gerada a partir do repositório de código (privado).',
    'Mostra a organização do projeto sem expor o conteúdo dos arquivos.',
    '',
    "Gerado em $data por ``scripts/gerar-estrutura.ps1``.",
    '',
    $cerca,
    ($linhas -join "`n"),
    $cerca
) -join "`n"

$diretorioSaida = Split-Path -Parent $Saida
if (-not (Test-Path -LiteralPath $diretorioSaida)) {
    New-Item -ItemType Directory -Path $diretorioSaida | Out-Null
}

Set-Content -LiteralPath $Saida -Value $conteudo -Encoding UTF8
Write-Host "Estrutura gerada em $Saida"

