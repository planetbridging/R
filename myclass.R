#--------------------------------------------myclass.R-----------------------------

MyClass <- setRefClass("MyClass",
                       fields = list(a = "numeric",
                                     b = "numeric"),

                       methods = list(
                         initialize =function(x,y){
                           print("Initializing")
                           a <<- x
                           b <<- y
                         },

                         printValues = function(){
                           print(a)
                           print(b)
                         }
                         )
                       )
#--------------------------------------------myclass.R-----------------------------
