
## Vehicle Speed Analysis - Rock Island, IL

---

## Contributor 
**Nabindra**
**Aryaman**
**Priyanjana**

---

## Introduction  
This project features an interactive **Shiny dashboard** that explores vehicle speed data collected by us. The app enables users to investigate when and how often vehicles exceed speed limits, how student observations vary, and how car types relate to speeding behavior. By categorizing speed and providing statistical visualizations, the dashboard supports insights into traffic patterns and safety awareness.

---

## Dictionary   

| Column Name           | Description                                         |
|------------------------|-----------------------------------------------------|
| `Time`                | Time of vehicle observation (HH:MM)                 |
| `Student`             | Student who recorded the data                       |
| `Speed (mph)`         | Speed of the vehicle in miles per hour             |
| `Car Type`            | Category of the vehicle (SUV, Sedan, etc.)         |
| `Over Speed Limit`    | Boolean indicating if vehicle exceeded 30 mph      |
| `Slowed Down`         | Indicates if the car slowed during observation     |
| `SpeedCategory`       | Derived: Within Limit / Slightly Over / Significantly Over |

---

## Data Cleaning   

- Converted `Time` column to time format for accurate plotting.
- Derived new variable `SpeedCategory`:
  - `≤ 30 mph`: **Within Limit**
  - `31–40 mph`: **Slightly Over**
  - `> 40 mph`: **Significantly Over**
- Removed rows with empty car types when needed for clarity.

---

## Visualizations & Analysis

### 1. Speed Category Distribution  

![image](https://github.com/user-attachments/assets/eca22b58-2fdc-4e3b-9300-4154675795b5)

| Category              | Count |
|-----------------------|-------|
| Within Limit (≤30)    | 73    |
| Slightly Over (31–40) | 100   |
| Significantly Over (>40) | 52 |

**Observation:**  
Roughly **67.56%** of all observed vehicles were over the speed limit, showing a major concern for speeding behavior in the area.

---

### 2. Speeding Summary Table  

| Metric               | Value   |
|----------------------|---------|
| Vehicles Within Limit| 73      |
| Slightly Over Limit  | 100     |
| Significantly Over   | 52      |
| **Total Speeding**   | **152** |
| Total Vehicles       | 225     |
| **% Speeding**       | **67.56%** |

---

### 3. Student Observations  
![image](https://github.com/user-attachments/assets/eb85a707-eb4a-4ff0-87e8-9e4882bccb80)

| Student     | Min (mph) | Max (mph) | Mean (mph) | Median (mph) |
|-------------|-----------|-----------|------------|--------------|
| Aryaman     | 25        | 59        | 32.16      | 29.0         |
| Nabindra    | 28        | 60        | 35.73      | 32.0         |
| Priyanjana  | 31        | 59        | 38.73      | 38.0         |

**Observation:**  
- **Priyanjana** observed the fastest vehicles on average.
- **Aryaman** recorded lower overall speeds, with a median well under the limit.
- **Nabindra** had a broad range of speeds with the highest maximum.

---

### 4. Overall Speed Statistics  

| Metric   | Value     |
|----------|-----------|
| Minimum  | 25 mph    |
| Maximum  | 60 mph    |
| Mean     | 35.54 mph |
| Median   | 33.0 mph  |

---

### 5. Car Type – Average Speed  
![image](https://github.com/user-attachments/assets/33012566-e27f-4689-aae0-84564143f303)

| Car Type | Average Speed (mph) |
|----------|---------------------|
| SUV      | 35.97               |
| Sedan    | 35.65               |
| Minivan  | 35.02               |
| Truck    | 34.97               |

**Observation:**  
All car types exhibit average speeds above the speed limit, with **SUVs** and **Sedans** topping the list.

---

### 6. Car Type – Speeding Breakdown  

| Car Type | Over Limit | Within Limit |
|----------|------------|--------------|
| Minivan  | 27         | 13           |
| SUV      | 52         | 24           |
| Sedan    | 48         | 26           |
| Truck    | 25         | 10           |

**Observation:**  
- **SUVs and Sedans** are the most common and the most frequently speeding.
- Even **Minivans** and **Trucks** show significant speeding instances.

---

### 7. Scatter Plot - Time v/s Speed
![image](https://github.com/user-attachments/assets/85d7a71f-4877-4f69-957c-119834a5e302)

---

## Tools & Libraries Used 

- `shiny`  
- `ggplot2`  
- `dplyr`  
- `readr`  
- `tidyr`  
- `readxl`  
- `httr`

---

## Conclusion  

This analysis revealed a concerning rate of speeding (over 67%) in Rock Island. Student observations differed in time, car types, and speed patterns. Priyanjana recorded the fastest speeds, while SUVs consistently topped both speed and violation counts. These findings suggest the need for awareness campaigns or enforcement focus on high-risk periods and vehicle categories. The interactive dashboard supports deeper, user-driven exploration of the dataset to inform public policy or classroom discussions.
