library(tidyverse)

# Load Data
file_path <- "~/Downloads/Consumer_Complaints.csv"
df <- read.csv(file_path, stringsAsFactors = FALSE)

# Format Date
df$Date.received <- as.Date(df$Date.received, format="%m/%d/%Y")
df$Date.sent.to.company <- as.Date(df$Date.sent.to.company, format="%m/%d/%Y")

# Standardize variables
df$Timely.response. <- tolower(df$Timely.response.)
df$Consumer.disputed. <- tolower(df$Consumer.disputed.)
df$Company.response.to.consumer <- tolower(df$Company.response.to.consumer)

# Fix missing values
df[is.na(df)] <- "Unknown"

# Remove duplicates
df <- df %>% distinct(Complaint.ID, .keep_all = TRUE)

# Summarize complaints by product
df_summary <- df %>% 
  group_by(Product) %>% 
  summarise(Complaint.Count = n()) %>% 
  arrange(desc(Complaint.Count))

# Save summary table
write.csv(df_summary, "Complaint_Summary.csv", row.names = FALSE)

# Generate a bar chart of complaints by product
ggplot(df_summary, aes(x = reorder(Product, -Complaint.Count), y = Complaint.Count)) +
  geom_bar(stat = "identity", fill = "blue") +
  coord_flip() +
  labs(title = "Number of Complaints by Product", x = "Product", y = "Complaint Count")
