# Load required libraries
library(tm)
library(wordcloud)
library(dplyr)
library(stopwords)
library(textstem)
library(RColorBrewer)
library(wordcloud2)
library(ggplot2)
library(patchwork)

# Step 1: Set working directory and load all lyric CSVs
setwd("D:/UKM/Master/2.Unstructed_Data/Project 1/songs")
files <- list.files(pattern = "lyric_.*\\.csv")
song_names <- c("7 Rings", "No Tears Left to Cry", "Into You", "God Is a Woman", "Get Well Soon")
names(files) <- song_names

# Step 2: Combine all lyrics into a single data frame
lyrics_list <- lapply(files, readLines)
names(lyrics_list) <- song_names
song_df <- data.frame(
  Song = rep(song_names, times = sapply(lyrics_list, length)),
  Line = unlist(lyrics_list)
)


# Step 3a: Define cleaner without custom stopwords
clean_lyrics_no_custom <- function(text) {
  corpus <- Corpus(VectorSource(text))
  corpus <- corpus %>%
    tm_map(content_transformer(tolower)) %>%
    tm_map(removePunctuation) %>%
    tm_map(removeNumbers) %>%
    tm_map(stripWhitespace) %>%
    tm_map(content_transformer(function(x) {
      words <- unlist(strsplit(x, " "))
      filtered <- words[!words %in% stopwords("en")]
      paste(filtered, collapse = " ")
    }))
  return(corpus)
}


# Step 3b: Define cleaner with custom stopwords
clean_lyrics_with_custom <- function(text) {
  custom_stopwords <- c(
    "aint", "cant", "dont", "gonna", "wanna", "gotta", "im", "youll", "youve",
    "get", "got", "just", "come", "know", "look", "see", "say", "make", "tell",
    "back", "now", "keep", "let", "thing", "put", "take", "yes", "want", "yeah","yuh"
  )
  all_stopwords <- c(stopwords("en"), custom_stopwords)
  corpus <- Corpus(VectorSource(text))
  corpus <- corpus %>%
    tm_map(content_transformer(tolower)) %>%
    tm_map(removePunctuation) %>%
    tm_map(removeNumbers) %>%
    tm_map(stripWhitespace) %>%
    tm_map(content_transformer(function(x) {
      words <- unlist(strsplit(x, " "))
      filtered <- words[!words %in% all_stopwords]
      paste(filtered, collapse = " ")
    }))
  return(corpus)
}


# =======================
# === VERSION 1: NO CUSTOM STOPWORDS REMOVED ===
# =======================
cat("==== NO CUSTOM STOPWORD REMOVAL ====\n")

# Step 4: Analyze all songs together
corpus_all_no <- clean_lyrics_no_custom(song_df$Line)
dtm_all_no <- DocumentTermMatrix(corpus_all_no)
freq_all_no <- colSums(as.matrix(dtm_all_no))
freq_all_no_sorted <- sort(freq_all_no, decreasing = TRUE)

# Step 5: Show top 10 frequent terms
cat("==== Top Words Across All Songs (No Custom Stopword Removal) ====\n")
print(head(data.frame(Term = names(freq_all_no_sorted), Frequency = freq_all_no_sorted), 10))

# Step 6b: Bar plot of top 15 words
top15_no <- head(freq_all_no_sorted, 15)
bar_df_no <- data.frame(word = names(top15_no), freq = as.numeric(top15_no))
bar_df_no_plot<-ggplot(bar_df_no, aes(x = reorder(word, freq), y = freq)) +
  geom_col(fill = "#69b3a2") +
  coord_flip() +
  labs(title = "Top 15 Words (No Custom Stopword Removal)",
       x = "Word", y = "Frequency") +
  theme_minimal()

# Step 6: Word cloud
wordcloud(
  words = names(freq_all_no_sorted),
  freq = freq_all_no_sorted,
  min.freq = 2,
  scale = c(4, 0.5),
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)

# Wordcloud2 star shape
wf <- data.frame(
  word = names(freq_all_no_sorted),
  freq = as.numeric(freq_all_no_sorted)
)
wordcloud2(wf, shape = "star", size = 0.5)

# =======================
# === VERSION 2: CUSTOM STOPWORDS REMOVED ===
# =======================
cat("\n\n==== CUSTOM STOPWORDS REMOVED ====\n")

# Step 4: Analyze all songs together
corpus_all_yes <- clean_lyrics_with_custom(song_df$Line)
dtm_all_yes <- DocumentTermMatrix(corpus_all_yes)
freq_all_yes <- colSums(as.matrix(dtm_all_yes))
freq_all_yes_sorted <- sort(freq_all_yes, decreasing = TRUE)

# Step 5: Show top 10 frequent terms
cat("==== Top Words Across All Songs (With Custom Stopword Removal) ====\n")
print(head(data.frame(Term = names(freq_all_yes_sorted), Frequency = freq_all_yes_sorted), 10))

# Step 6: Word cloud
wordcloud(
  words = names(freq_all_yes_sorted),
  freq = freq_all_yes_sorted,
  min.freq = 2,
  scale = c(4, 0.5),
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)

# Wordcloud2 star shape
wf1 <- data.frame(
  word = names(freq_all_yes_sorted),
  freq = as.numeric(freq_all_yes_sorted)
)
wordcloud2(wf1, shape = "star", size = 0.5)

# Step 6b: Bar plot of top 15 words
top15_yes <- head(freq_all_yes_sorted, 15)
bar_df_yes <- data.frame(word = names(top15_yes), freq = as.numeric(top15_yes))
bar_df_yes_plot<- ggplot(bar_df_yes, aes(x = reorder(word, freq), y = freq)) +
  geom_col(fill = "#f8766d") +
  coord_flip() +
  labs(title = "Top 15 Words (With Custom Stopword Removal)",
       x = "Word", y = "Frequency") +
  theme_minimal()

# Sentiment Analysis (With Custom Stopwords)---------------------------------------------------------------
# Load libraries
library(tidytext)
library(tidyr)
library(dplyr)
library(ggplot2)

# Get the bing lexicon
bing <- get_sentiments("bing")

# Step 1: Convert cleaned lyrics to character vector
cleaned_lines <- sapply(corpus_all_yes, as.character)

# Step 2: Create a data frame with song names and lines
song_text_df <- data.frame(
  Song = song_df$Song,
  text = cleaned_lines,
  stringsAsFactors = FALSE
)

# Step 3: Tokenize and join with bing sentiment
bing_sentiment <- song_text_df %>%
  unnest_tokens(word, text) %>%
  inner_join(bing, by = "word") %>%
  count(Song, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%
  mutate(net_sentiment = positive - negative)

print(bing_sentiment)

bing_sentiment_plot<-ggplot(bing_sentiment, aes(x = Song, y = net_sentiment, fill = Song)) +
  geom_col(show.legend = FALSE) +
  labs(title = "Net Sentiment by Song (Bing Lexicon)", y = "Net Sentiment", x = "Song") +
  theme_minimal()

# NRC -----------------------------------------------------------------------------------------------------
# Make sure the required packages are loaded
library(syuzhet)
library(ggplot2)

# Step 1: Get NRC sentiment for each line (from cleaned lyrics with custom stopwords)
nrc_data <- get_nrc_sentiment(cleaned_lines)

# Step 2: Summarize only the 8 emotion categories
nrc_emotions <- colSums(nrc_data[, 1:8])

# Step 3: Convert to data frame for plotting
emotion_df <- data.frame(
  Emotion = names(nrc_emotions),
  Count = as.numeric(nrc_emotions)
)

# Step 4: Plot bar chart of emotions
emotion_df_plot<-ggplot(emotion_df, aes(x = reorder(Emotion, Count), y = Count, fill = Emotion)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(title = "Distribution of Emotions Across All Lyrics (NRC)",
       x = "Emotion", y = "Word Count") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3")

bing_sentiment_plot | emotion_df_plot
# =======================
# === VERSION 3: INDIVIDUAL SONG DTM ===
# =======================

# Step 7: Top terms per individual song
top_terms_with_custom <- list()
for (song in names(files)) {
  lyrics <- readLines(files[song])
  cleaned <- clean_lyrics_with_custom(lyrics)
  dtm <- DocumentTermMatrix(cleaned)
  freq <- sort(colSums(as.matrix(dtm)), decreasing = TRUE)
  top_terms_with_custom[[song]] <- head(freq, 10)
}

# Step 8: Print top 10 words for each song
for (song in names(top_terms_with_custom)) {
  cat("\n---- Top Words for (With Custom Stopword):", song, "----\n")
  print(data.frame(Term = names(top_terms_with_custom[[song]]), 
                   Frequency = top_terms_with_custom[[song]]))
}

# Step 7 & 8: Extract top 10 terms for each song into a single data frame
top_terms_df <- data.frame()

for (song in names(files)) {
  lyrics <- readLines(files[song])
  cleaned <- clean_lyrics_with_custom(lyrics)
  dtm <- DocumentTermMatrix(cleaned)
  freq <- sort(colSums(as.matrix(dtm)), decreasing = TRUE)
  top10 <- head(freq, 10)
  song_df <- data.frame(
    Song = song,
    Term = names(top10),
    Frequency = as.numeric(top10)
  )
  top_terms_df <- rbind(top_terms_df, song_df)
}

library(ggplot2)

ggplot(top_terms_df, aes(x = reorder(Term, Frequency), y = Frequency, fill = Song)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ Song, scales = "free_y") +
  coord_flip() +
  labs(title = "Top 10 Words per Song (With Custom Stopwords)",
       x = "Word", y = "Frequency") +
  theme_minimal() +
  theme(strip.text = element_text(face = "bold"))


# Check BING/NRC words-----------------------------------------------------------------------
library(tidytext)
library(syuzhet)
library(dplyr)

# Custom stopwords
custom_stopwords <- c(
  "aint", "cant", "dont", "gonna", "wanna", "gotta", "im", "youll", "youve",
  "get", "got", "just", "come", "know", "look", "see", "say", "make", "tell",
  "back", "now", "keep", "let", "thing", "put", "take", "yes", "want", "yeah", "yuh"
)

# Load Bing and NRC
bing <- get_sentiments("bing")
nrc <- get_sentiments("nrc")

# Check which custom words exist in Bing
custom_in_bing <- intersect(custom_stopwords, bing$word)
cat("Words in Bing:", paste(custom_in_bing, collapse = ", "), "\n")

# Check which custom words exist in NRC
custom_in_nrc <- intersect(custom_stopwords, nrc$word)
cat("Words in NRC:", paste(custom_in_nrc, collapse = ", "), "\n")
#------------------------------------------------------------------------------------



bar_df_no_plot | bar_df_yes_plot

