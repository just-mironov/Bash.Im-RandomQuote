<#
    Выводим случайную цитату с сайта bash.im из "Лучшего" за последние 5 лет.
    Чтобы цитата выводилась при запуске PowerShell - нужно добавить весь код из файла в файл профиля.
    Открыть файл профиля (powershell команда):
    notepad $profile
    Если выходит ошибка, значит файла профиля еще нет - нужно его создать:
    New-Item -path $profile -type file -force
    После чего открыть, добавить код и сохранить
#>

$quoteslist = New-Object Collections.ArrayList
Function Load-Bash #Загрузка цитат с баша
{
$cur_year = Get-Date -uformat %Y
$old_year = $cur_year - 5

$url = "http://bash.im/best/"

for ([int] $i = $cur_year; $i -gt $old_year; $i--)
    {
    $page = $url + $i
    $WebResponse = (Invoke-WebRequest -Uri $page -UserAgent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36")

    $quotes = ($WebResponse.ParsedHtml.DocumentElement.GetElementsByTagName('div') | Where { $_.ClassName -match '\bquote__body\b'}).InnerText
    $add = $quoteslist.Add($quotes)
    }
}

Function Bash # Функция, чтобы можно было вручную выводить случайную цитату
{
  if ($quoteslist) { } else { Load-Bash }
  $randomYear = get-random $quoteslist.Count
  $randomQuote = get-random $quoteslist[$randomYear].Count
  Write-Host $quoteslist[$randomYear].Get($randomQuote) -foreground Yellow
  echo ""
}

Bash
