#--------------------------------------------main-----------------------------
#Reference external code file
source("ObjWebScrap.R")

#imports
library("tcltk")




mywait <- function() {
	input <- ""
	
	window <- tktoplevel()
	tkwm.title(window, "Entry widget test")
	frame <- ttkframe(window, padding = c(3,3,12,12)); tkpack(frame, expand = TRUE, fill = "both")
	
	txt_var <- tclVar("Britney Spears")
	button <- ttkbutton(window, text = "focus out onto this", 
               command = function() {
					print("Searching for")
					tkdestroy(window)
               })
	entry <- ttkentry(window, textvariable = txt_var)
	tkpack(entry,button)
	tkwait.window(entry)
	searching <- tclvalue(txt_var)
	print(searching)
	
	newfolder = str_replace(searching, " ","_")
	
	if(file.exists(newfolder) == FALSE){
		print("Creating search")
		print(newfolder)
		dir.create(newfolder)
		
	}
	oweb <- ObjWebScrap$new()
	oweb$WikiAlbums(newfolder)
	
}


mywait()

#--------------------------------------------main-----------------------------

