# Consumer Complaints Analysis

This is an analysis of the ConsumerComplaints Dataset which consists of consumer complaints related to various financial products and services. 

---
### Cleaning The Data
1. Formatting Date Columns
Converts the Date.received and Date.sent.to.company columns to Date format using as.Date(), following the format as "%m/%d/%Y".
```
df$Date.received <- as.Date(df$Date.received, format="%m/%d/%Y")
df$Date.sent.to.company <- as.Date(df$Date.sent.to.company, format="%m/%d/%Y")
```
2. Standardizing Text Variables
Converts values in Timely.response., Consumer.disputed., and Company.response.to.consumer columns to lowercase to ensures consistency in categorical values.
```
df$Timely.response. <- tolower(df$Timely.response.)
df$Consumer.disputed. <- tolower(df$Consumer.disputed.)
df$Company.response.to.consumer <- tolower(df$Company.response.to.consumer)
```
3. Handling Missing Values
Replaces all NA values in the dataset with "Unknown" to ensure missing data is explicitly labeled.
```
df[is.na(df)] <- "Unknown"
```
4. Removing Duplicates
Uses distinct(Complaint.ID, .keep_all = TRUE) to remove duplicate complaints based on the Complaint.ID column while keeping the first occurrence.
```
df <- df %>% distinct(Complaint.ID, .keep_all = TRUE)
```
5. Summarizing Data
Groups the data by Product and counts the number of complaints for each product.
Sorts the summary in descending order of complaint count.
```
df_summary <- df %>% 
  group_by(Product) %>% 
  summarise(Complaint.Count = n()) %>% 
  arrange(desc(Complaint.Count))
```

## Below are key insights that I have extracted:

### Most Commonly Complained About Products and Issues
  These are the products and issues that the consumers complained about the most. This is valuable because it helps businesses focus on the key areas of consumer dissatisfaction.
```
ggplot(df_summary, aes(x = reorder(Product, -Complaint.Count), y = Complaint.Count)) +
  geom_bar(stat = "identity", fill = "blue") +
  coord_flip() +
  labs(title = "Number of Complaints by Product", x = "Product", y = "Complaint Count")
```
![Rplot](https://github.com/user-attachments/assets/25514c6d-7047-40c2-865c-17d5753b3701)

  Top 10 Most Complained About Products
```
product_counts <- df %>%
  count(Product, sort = TRUE) %>%
  top_n(10)

ggplot(product_counts, aes(x = reorder(Product, n), y = n, fill = Product)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Top 10 Most Complained About Products",
       x = "Product", y = "Number of Complaints") +
  theme_minimal()
```
![MostComplainedAboutProducts](https://github.com/user-attachments/assets/aef5e5f7-0679-4ad3-9bb8-63ef8562dec6)

---
### Trend Analysis of Complaints Over Time
  Here is a visualization of how complaints have occured over time. This is valuable to identify trends, spikes, and improvements.
```
df_trend <- df %>%
  group_by(YearMonth = floor_date(Date.received, "month")) %>%
  summarise(Complaints = n())

ggplot(df_trend, aes(x = YearMonth, y = Complaints)) +
  geom_line(color = "blue", size = 1) +
  labs(title = "Trend of Consumer Complaints Over Time",
       x = "Year-Month", y = "Number of Complaints") +
  theme_minimal()
```
![ComplaintsOverTime](https://github.com/user-attachments/assets/288b9e64-75b2-4d89-8f5c-2673f3870b58)

---
### Sentiment Analysis of Consumer Complaints
  Here is a sentiment analysis using Bing and NRC, this helps understand consumer emotions and their intensity.
```
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
```
![SentimentAnalysis](https://github.com/user-attachments/assets/f8055560-9716-4015-9011-2c078e2f6ac1)
![NRC](https://github.com/user-attachments/assets/5c5aaba3-16ee-4204-902c-b642e678e0e2)

---
### Distribution of Company Responses
  This graph analyzes the distribution of company responses which helps identify how well businesses handle consumer complaints. 
```
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
```
![DistributionOfCompanyResources](https://github.com/user-attachments/assets/9d8c910c-4bde-4f60-a30c-83f296c47a6e)

