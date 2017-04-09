fazendaSP<-function(ano,codigo)
{
library(RCurl)
library(XML)
# O objeto (hd) abaixo contém contém o header
hd<-c(Accept = "text/xml",
Accept = "multipart/*",
'Content-Type' = "text/xml; charset=utf-8",
SOAPAction= "http://fazenda.sp.gov.br/wstransparencia/ConsultarDespesas"
)
# O objeto (body) abaixo contém o body com as respectivas variáveis. Meu interesse está somente no código do órgão e no ano.
body<-paste0(
'<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Header>
<AutenticacaoHeader xmlns="http://fazenda.sp.gov.br/wstransparencia">
<Usuario></Usuario>
<Senha></Senha>
</AutenticacaoHeader>
</soap:Header>
<soap:Body>
<ConsultarDespesas xmlns="http://fazenda.sp.gov.br/wstransparencia">
<ano>'
,ano,
'</ano>
<codigoOrgao>',
codigo,
'</codigoOrgao> # Quero somente a despesa do MP
<codigoUo></codigoUo>
<codigoUnidadeGestora></codigoUnidadeGestora>
<codigoFonteRecursos></codigoFonteRecursos>
<codigoTipoLicitacao></codigoTipoLicitacao>
<codigoFuncao></codigoFuncao>
<codigoSubfuncao></codigoSubfuncao>
<codigoPrograma></codigoPrograma>
<codigoAcao></codigoAcao>
<codigoFuncionalProgramatica></codigoFuncionalProgramatica>
<codigoMunicipio></codigoMunicipio>
<codigoCategoria></codigoCategoria>
<codigoGrupo></codigoGrupo>
<codigoModalidade></codigoModalidade>
<codigoElemento></codigoElemento>
<naturezaDespesa></naturezaDespesa>
<flagCredor>0</flagCredor>
<cgcCpfCredor></cgcCpfCredor>
<nomeCredor></nomeCredor>
<flagEmpenhado>1</flagEmpenhado>
<flagLiquidado>0</flagLiquidado>
<flagPago>0</flagPago>
</ConsultarDespesas>
</soap:Body>
</soap:Envelope>'
)
h = basicTextGatherer() # A função curlPerfom não deposita os resultados em lugar algum,
# Eu preciso desse objeto (h) com funções que coletam o conteúdo.
### Agora estamos prontos, temos o header, o body, a função para coletar e, além disso, devido a um provavel
### malfuncionamento do ssl, pedir para ignorar a verificação
curlPerform(url = "https://webservices.fazenda.sp.gov.br/WSTransparencia/TransparenciaServico.asmx?",
httpheader = hd,
postfields = body,
.opts = list(ssl.verifypeer = FALSE),
writefunction=h$update
)
a<-h$value()
b<-xmlParse(a)
c<-xmlToList(b)
d<-do.call("rbind",c$Body$ConsultarDespesasResponse$ConsultarDespesasResult$ListaItensDespesa)
e<-as.data.frame(d)
rownames(e)<-1:nrow(e)
return(e)
}
