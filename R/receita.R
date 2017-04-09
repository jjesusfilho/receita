#' Função receita
#'
#' Esta função extrai os dados da receita federal
#' @param ano Ano 
#' @param CodigoOS Código Órgão Superior 
#' @param CodigoOS Código Órgão Superior 
#' @param CodigoUG Código Unidade Gestora
#' @param CodigoED Código Elementos da Despesa
#' @keywords receita, transparencia
#' @export
#' @examples
#' receita(ano=2016,CodigoOS=30000,CodigoOrgao=30108,CodigoUG=200340)

receita<-function(ano=format(Sys.Date(),"%Y"),CodigoOS=0,CodigoOrgao=0,CodigoUG=0,CodigoED=0){
    url<-sprintf("http://www.portaltransparencia.gov.br/PortalComprasDiretasOEUnidadeGestora.asp?Ano=%d&CodigoOS=%d&CodigoOrgao=%d&CodigoUG=%d&CodigoED=%d",ano,CodigoOS,CodigoOrgao,CodigoUG,CodigoED)
    p<-read_html(url) %>% 
    html_node(xpath="//*[@class='paginaAtual']") %>% 
    html_text() %>% 
    str_extract("\\d+$") %>% 
    as.numeric()
  s<-list()
  for (i in 1:p){
  url<-sprintf("http://www.portaltransparencia.gov.br/PortalComprasDiretasOEUnidadeGestora.asp?Ano=%d&CodigoOS=%d&CodigoOrgao=%d&CodigoUG=%d&CodigoED=%d&Pagina=%d",ano,CodigoOS,CodigoOrgao,CodigoUG,CodigoED,i)
    s[[i]]<-read_html(url) %>% 
      html_nodes("table") %>% 
      .[2] %>% 
      html_table() %>% 
      do.call(rbind,.)
  }
  s<-do.call(rbind,s)
  s$ano<-ano
  return(s)
}


df<-data.frame()
for (i in 2010:2016){
  f<-receita(ano=i,CodigoOS=30000,CodigoOrgao=30108,CodigoUG=200340)
  df<-rbind(df,f)
}





## Obtendo despesas diárias do Ministério da Justiça 

mj<-"http://www.portaltransparencia.gov.br/despesasdiarias/resultado?consulta=rapida&periodoInicio=01%2F01%2F2017&periodoFim=31%2F01%2F2017&fase=EMP&codigoOS=30000&codigoFavorecido="

p<-mj %>% read_html() %>% 
  html_node(xpath="//*[@class='paginaXdeN']") %>% 
  html_text() %>% 
  str_extract("\\d+$") %>% 
  as.numeric()

m<-data.frame()

for (i in 247:269){
  m1<-paste0(mj,"&pagina=",i) %>% 
        read_html() %>% 
   html_node(xpath="//*[@class='tabela']") %>% 
    html_table()
  m<-rbind(m,m1)
}







m2<-map(m,subset(m,))

m1<-data.frame()
for (i in 1:length(m)){
  m1<-rbind(m1,m[[i]][[7]])
}


m1<-m %>% at_depth(2,function(x) do.call(rbind,x))

m2<-m %>% at_depth(3,rbind)

m2<-m %>% at_depth(2,transpose)

m2<-list()

m1<-m[[7]]
m2<-m[[7]]
