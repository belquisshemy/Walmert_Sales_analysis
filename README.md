# Walmart Sales Data Analysis (MySQL Focused)
## Project Overview
![Project Pipeline](https://github.com/belquisshemy/Walmert_Sales_analysis/blob/main/walmart_project_pipeline.png)
This project presents an end-to-end data analysis solution, extracting critical business insights from Walmart sales data. It leverages Python for robust data processing and cleaning, followed by in-depth analytical querying using MySQL. The aim is to uncover key sales trends, customer behaviors, and profitability drivers to support strategic business decisions.
---

## Key Questions Addressed & Insights
This project dives into several key business questions to provide actionable insights:

### Busiest Day Analysis by Branch:

Identified the day of the week (e.g., Monday, Saturday) that recorded the highest number of transactions for each branch. This is crucial for optimizing staffing and operational planning.

### Category Performance by City:

Determined the average, minimum, and maximum product ratings for each product category within every city.

Identified the top 3 performing product categories in each city based on total revenue, alongside their percentage contribution to the city's overall revenue. This helps pinpoint regional category strengths and areas for improvement.

### Profitability by Category:

Calculated the total profit for each product category based on unit_price, quantity, and profit_margin, providing a clear view of the most profitable product lines.

### Common Payment Methods by Branch:

Uncovered the most frequently used payment method in each branch, offering insights into customer preferences and aiding in payment system optimization.

### Sales Categorization by Time of Day:

Categorized sales into 'Morning', 'Afternoon', and 'Evening' shifts and quantified the number of invoices processed in each period. This reveals peak shopping hours, valuable for resource allocation and marketing campaigns.

### Rating vs. Sales Correlation:

Analyzed the relationship between product ratings and sales volume to assess if higher-rated items generally result in higher sales. This provides insights into the impact of product quality/satisfaction on purchasing behavior.

## Technical Stack
- **Programming Language: Python 3.x**

- **Database: MySQL**

- **Key Python Libraries**:

  - `pandas`: For data manipulation and analysis.

  - `sqlalchemy`: For connecting Python with MySQL.

  - `mysql-connector-python`: MySQL database connector for Python.

Data Source: Kaggle Walmart Sales Dataset

## Project Structure
```plaintext
|-- data/                     # Raw data and cleaned/transformed data
|-- sql_queries/              # All SQL scripts used for analysis
|-- notebooks/                # Jupyter Notebooks for Python data processing and exploratory analysis
|-- README.md                 # Project documentation
|-- requirements.txt          # List of required Python libraries
|-- main.py                   # Main script for data ingestion, cleaning, and loading
```
---

## Getting Started
To run this project locally, ensure you have Python 3.x and MySQL installed.

1. Clone the repository:
  ```bash
  git clone <your-repo-url>
  ```
2. Install Python dependencies:
  ```bash
  pip install -r requirements.txt
  ```
3. Kaggle Data Setup:

  Obtain your Kaggle API token (kaggle.json) from your Kaggle profile settings.
  
  Place kaggle.json in your local ~/.kaggle/ directory.
  
  Use the Kaggle API to download the Walmart sales dataset into the data/ folder (refer to main.py or notebooks for specific Kaggle commands).

MySQL Database Setup:

Ensure your MySQL server is running.

Update database connection details (host, user, password, database name) in main.py or a dedicated configuration file.

Run main.py to process the data and load it into your MySQL database.

Run SQL Queries:

Navigate to the sql_queries/ directory to execute the analytical queries directly on your MySQL database.

## Results & Insights (Summary)
Based on the analysis:
**Payment Methods**: Credit card is the most frequently used payment method across branches, followed by e-wallet and then cash.

**Branch Performance**: Each branch exhibits unique performance characteristics regarding its top-ranked categories.

**Busiest Days**: While the busiest day of the week varies by individual branch, generally, weekdays tend to be the most active.

**Profitability**: "Fashion and Accessories" generated the highest total profit, followed by "Home and Lifestyle," and then "Electronic Accessories."

**Sales Shifts**: The afternoon shift is consistently the busiest, followed by evening, and then morning.

**Seasonal Trends**: December, November, and January appear to be the peak months for sales activity.

**Rating vs. Sales**: There is no clear correlation indicating that higher-rated items consistently result in higher sales volume.
## Future Enhancements
Integration with a business intelligence tool (e.g., Tableau, Power BI) for interactive dashboards.

Deployment of the data pipeline for automated daily/weekly updates.

Advanced statistical modeling to predict sales or customer behavior.


## Acknowledgments
Data Source: Kaggle’s Walmart Sales Dataset
Inspiration: "Zero Analyst" YouTube Channel (Najir H.) for project structure and problem-solving approach.
