# Import and attach libraries/packages

pkgs <- c("devtools","vosonSML","magrittr","tm","igraph","stringr")
lapply(pkgs, library, character.only = TRUE)

#library(writexl)
#library(openxlsx)

# Set up authentication variables

appname <- "declair"
my_api_key <- "33iRrzrqiUk28ChE1kaZN7bIv"
my_api_secret <- "VPtlcriRrID3sjYaS5cvz8SnNSsuBWZ5TENwhWAfXwvrWm0fFv"
my_access_token <- "1161974032146677761-3Y7CN4vb4lbli662VVOmqoAL1R7egt"
my_access_token_secret <- "AUbfdyK4VaPUKregw88qZJ5wLqaiaBLnCATSX965fWahW"


# Authenticate and get data

myTwitterData <- Authenticate("twitter",
                              appName= appname,
                              apiKey=my_api_key,
                              apiSecret=my_api_secret,
                              accessToken=my_access_token,
                              accessTokenSecret=my_access_token_secret,
                              useCachedToken = F) %>%
  Collect(searchTerm="Britney Spears", language="en", numTweets=2000, writeToFile=TRUE)


# View Collected Twitter Data
#write_xlsx(x = myTwitterData, path = "daily.xlsx", col_names = TRUE)
?write.table
write.table(myTwitterData, file="BritB.csv", sep = ",")
#write.csv(myTwitterData, file = "foo.csv")
#write.xlsx(myTwitterData,file="BritTweets.xlsx")

View(myTwitterData)


# Create Actor Network and Graph

g_twitter_actor_network <- myTwitterData %>% Create("actor")
g_twitter_actor_graph <- Graph(g_twitter_actor_network)

V(g_twitter_actor_graph)$name <- V(g_twitter_actor_graph)$screen_name


# Write Graph to File

write.graph(g_twitter_actor_graph, "TwitterActor.graphml", format="graphml")


# Run Page Rank Algorithm to Find Important Users

pageRank_auspol_actor <- sort(page.rank(g_twitter_actor_graph)$vector, decreasing=TRUE)
head(pageRank_auspol_actor, n=3)


# Create Semantic Network and Graph (and Write to File)

g_twitter_semantic_network <- myTwitterData %>% Create("semantic", stopwordsEnglish = T)
g_twitter_semantic_graph <- Graph(g_twitter_semantic_network)
write.graph(g_twitter_semantic_graph, "TwitterSemantic.graphml", format="graphml")


# Run Page Rank Algorithm to Find Top 10 Important Terms

pageRank_auspol_semantic <- sort(page_rank(g_twitter_semantic_graph)$vector, decreasing=TRUE)
head(pageRank_auspol_semantic, n=10)


# Try the Analysis Again but with a Semantic Network of the 50% most Frequent Terms (Complete this part of the script yourself!)

g_twitter_semantic_network_allTerms <- myTwitterData %>% 
  Create("semantic", termFreq=50, removeTermsOrHashtags=c("#auspol"))
g_twitter_semantic_graph_allTerms <- Graph(g_twitter_semantic_network_allTerms)
write.graph(g_twitter_semantic_graph_allTerms, "TwitterSemanticAllTerms.graphml", format="graphml")

