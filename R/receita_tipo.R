receita_tipo<-function(ano=format(Sys.Date(),"%Y"),CogigoGD=0,CodigoED=0){
  url<-sprintf("http://www.portaldatransparencia.gov.br/PortalComprasDiretasEDOrgaoSuperior.asp?Ano=%d&CodigoGD=%d&CodigoED=%d",ano,CodigoGD,CodigoED)
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

