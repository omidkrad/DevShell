function Search-Google
{
    start "https://www.google.com/?q=$args"
}
Set-Alias g Search-Google
Set-Alias google Search-Google

function Search-Bing
{
    start "https://www.bing.com/search?q=$args"
}
Set-Alias b Search-Bing
Set-Alias bing Search-Bing
