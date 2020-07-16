#--------------------------------------------ObjWebScrap.R-----------------------------
#library(XML)
library('xml2')
library('rvest')
library('stringr')

ObjWebScrap <- setRefClass("ObjWebScrap",
                       fields = list(),

                       methods = list(
                         initialize =function(){
                           print("Web scraping")
  
                         },

							 installPackages = function(){
								#install.packages('selectr')
								install.packages('stringr')
								install.packages('XML')
								install.packages('xml2')
								install.packages('rvest')
								install.packages('tcltk')
							 },
							 WriteNewFile = function(fold,name, data){
								saving = paste(fold,"/",name,"_save.txt")
								saving = str_replace(saving, " ", "")
								saving = str_replace(saving, " ", "")
								fileConn<-file(saving)
								writeLines(c("Hello","World"), fileConn)
								close(fileConn)
							 },
							 WikiSongs = function(link){
								countSongs = 0
								link = str_replace(link, " ","")
								linkFix = paste('https://en.wikipedia.org',link)
								linkFix = str_replace(linkFix, " ","")
								print(paste("Checking: " ,linkFix))
								webpage <- read_html(linkFix)
								tbl <- html_nodes(webpage,'.tracklist')
								#tbls <- xml_find_all(webpage, ".//table")
								for(t in tbl){
									tr <- xml_find_all(t, ".//tr")
									for(trs in tr){
										#print("tr")
										td <- xml_find_all(trs, ".//td")
										
										if(length(td) > 0){
											print(xml_text(td[2]))
										countSongs = countSongs + 1
										}
										
									}
									break									
								}
								countSongs = countSongs - 1
								print(paste("Song count: ",countSongs))
							 },
							 WikiAlbums = function(search){
								print('testing web')
								foundData = FALSE
								
								buildLink = paste('https://en.wikipedia.org/wiki/',search,'_discography')
								buildLink = str_replace(buildLink, " ","")
								buildLink = str_replace(buildLink, " ","")
								print(buildLink)
								webpage <- read_html(buildLink)
								
								tbls <- html_nodes(webpage, "table")

								for (t in tbls) {
								
									if(foundData == FALSE){
									
										if(str_detect(t, "Release")){
											foundData = TRUE
											tr <- xml_find_all(t, ".//tr")
											
											
											
											for(trs in tr){
												if(str_detect(trs, "Release")){
												
													txtAlbum = ""
													txtAlbumDetails = ""
													link = ""
													
													th <- xml_find_all(trs, ".//th")
													td <- xml_find_all(trs, ".//td")
													
													li <- xml_find_all(td[1], ".//li")
													
													a <- xml_find_all(th, ".//a")
													for(album in a){
														txt = xml_text(album)
														txtAlbum = txt
														link = xml_attr(album, "href")
													}
													
													txtAlbumDetails = xml_text(li[1])
													
													txtAlbum = str_replace(txtAlbum, "\n","")
													txtAlbumDetails = str_replace(txtAlbumDetails, "&nbsp;","")
													
													output = paste(txtAlbum," : ",txtAlbumDetails)
													
													WikiSongs(link)
													
													print(output)
													
												}
											}

										}
									
									
									}
								
									
								}
								
								
								
								
							 }
                         )
                       )
#--------------------------------------------ObjWebScrap.R-----------------------------
