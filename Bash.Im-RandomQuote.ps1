<#
    Выводим случайную цитату с сайта bash.im из "Лучшего" за последние 5 лет.

    Чтобы цитата выводилась при запуске PowerShell - нужно добавить весь код из файла в файл профиля.
    Открыть файл профиля (powershell команда):
    notepad $profile

    Если выходит ошибка, значит файла профиля еще нет - нужно его создать:
    New-Item -path $profile -type file -force

    После чего открыть, добавить код и сохранить
#>

Add-Type -AssemblyName System.Web
$utils = [Web.HttpUtility]
$wc = New-Object Net.WebClient
$quoteslist = New-Object Collections.ArrayList

$cur_year = Get-Date -uformat %Y
$old_year = $cur_year - 5

$url = "http://bash.im/bestyear/"

for ([int] $i = $cur_year; $i -gt $old_year; $i--)
{
    $page = $wc.DownloadString($url + $i)
    $matches = [regex]::Matches($page, "<div class=""text"">(.*?)</div>")

    #$matches | ForEach-Object { $count = $quoteslist.Add($utils::HtmlDecode($_.Groups[1].Value.Replace("<br>", "`r`n"))) }

    ForEach ($match in $matches)
    {
        $count = $quoteslist.Add($utils::HtmlDecode($match.Groups[1].Value.Replace("<br>", "`r`n")))
    }
}

Function Bash # Функция, чтобы можно было вручную выводить случайную цитату
{
  Write-Host $quoteslist[(Get-Random $quoteslist.Count)] -foreground Yellow
  echo ""
}

Bash