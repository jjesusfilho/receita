number_br<-function(str){
  str<-stringr::str_replace_all(str,"\\.","")
  str<-stringr::str_replace_all(str,",",".")
  str<-stringr::str_trim(str)
  num<-as.numeric(str)
  return(num)
}