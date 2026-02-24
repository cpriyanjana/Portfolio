library(tidyverse)
library(lubridate)
library(tidytext)
library(syuzhet)
library(ggplot2)

# Load the dataset
file_path <- "~/Downloads/Consumer_Complaints.csv"
df <- read.csv(file_path, stringsAsFactors = FALSE)

# Data Cleanup
df <- df %>%
  mutate(Date.received = mdy(Date.received)) %>% # Convert date format
  drop_na(Product, Issue)  # Remove rows with missing Product/Issue

# Bar chart of complaints by product
ggplot(df_summary, aes(x = reorder(Product, -Complaint.Count), y = Complaint.Count)) +
  geom_bar(stat = "identity", fill = "blue") +
  coord_flip() +
  labs(title = "Number of Complaints by Product", x = "Product", y = "Complaint Count")

# 1. Most Complained About Products
product_counts <- df %>%
  count(Product, sort = TRUE) %>%
  top_n(10)

ggplot(product_counts, aes(x = reorder(Product, n), y = n, fill = Product)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Top 10 Most Complained About Products",
       x = "Product", y = "Number of Complaints") +
  theme_minimal()

# 2. Trend Analysis of Complaints
df_trend <- df %>%
  group_by(YearMonth = floor_date(Date.received, "month")) %>%
  summarise(Complaints = n())

ggplot(df_trend, aes(x = YearMonth, y = Complaints)) +
  geom_line(color = "blue", size = 1) +
  labs(title = "Trend of Consumer Complaints Over Time",
       x = "Year-Month", y = "Number of Complaints") +
  theme_minimal()

# 3. Sentiment Analysis of Complaints
# Keep only rows with complaint narratives
df_sentiment <- df %>%
  filter(!is.na(Consumer.complaint.narrative))

tokens <- df_sentiment %>%
  unnest_tokens(word, Consumer.complaint.narrative) 

# Bing Sentiment Analysis
bing_sentiment <- tokens %>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment)

ggplot(bing_sentiment, aes(x = sentiment, y = n, fill = sentiment)) +
  geom_bar(stat = "identity") +
  labs(title = "Bing Sentiment Analysis of Complaints",
       x = "Sentiment", y = "Count") +
  theme_minimal()
theme(axis.text.y = element_text(size = 10))

# NRC Sentiment Analysis
nrc_sentiment <- tokens %>%
  inner_join(get_sentiments("nrc")) %>%
  count(sentiment)

ggplot(nrc_sentiment, aes(x = reorder(sentiment, n), y = n, fill = sentiment)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "NRC Sentiment Analysis of Complaints",
       x = "Sentiment", y = "Count") +
  theme_minimal()
  theme(axis.text.y = element_text(size = 10))

# 4. Distribution of Company Responses
response_counts <- df %>%
  count(Company.response.to.consumer, sort = TRUE)

ggplot(response_counts, aes(x = reorder(Company.response.to.consumer, n), y = n, fill = Company.response.to.consumer)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_y_continuous(labels = scales::comma) +  # Format Y-axis for readability
  labs(title = "Distribution of Company Responses to Complaints",
       x = "Company Response", y = "Number of Complaints") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 10))
