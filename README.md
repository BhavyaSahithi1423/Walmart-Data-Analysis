# Walmart Data Analysis

## Project Overview
This project analyzes Walmart sales data using Python and SQL. The dataset was obtained from Kaggle and includes transactional details such as invoice ID, branch, city, category, unit price, quantity, date, time, payment method, rating, and profit margin. The analysis aims to derive meaningful insights regarding sales trends, customer preferences, and store performance.

## Tools & Technologies Used
- **Python** (pandas, pymysql, SQLAlchemy)
- **MySQL** (SQL queries for data analysis)
- **Jupyter Notebook**
- **Kaggle Dataset**

## Project Structure
```
├── project.ipynb  # Jupyter Notebook for analysis
├── walmart_clean_data.csv  # Processed dataset
├── walmart sql.sql  # SQL queries for insights
```

## Data Cleaning & Preparation
### Python (project.ipynb)
1. **Data Loading & Exploration**
   - Loaded the dataset using `pandas.read_csv()`.
   - Checked for missing values, duplicates, and data types.
2. **Data Cleaning**
   - Removed duplicates.
   - Dropped rows with missing values.
   - Converted `unit_price` from string to float by removing the dollar sign.
   - Created a `total` column (`unit_price * quantity`).
3. **Exporting Data**
   - Saved the cleaned data as `walmart_clean_data.csv`.
4. **MySQL Integration**
   - Established a connection using `pymysql` and `SQLAlchemy`.
   - Uploaded the cleaned data into the MySQL database (`walmart_db`).

## SQL Analysis
### Key SQL Queries
1. **Transaction Count Per Payment Method**
   ```sql
   SELECT payment_method, COUNT(*) AS no_payments, SUM(quantity) AS no_qty_sold
   FROM walmart
   GROUP BY payment_method;
   ```
2. **Highest-Rated Category in Each Branch**
   ```sql
   SELECT branch, category, AVG(rating) AS avg_rating
   FROM walmart
   GROUP BY branch, category
   ORDER BY avg_rating DESC;
   ```
3. **Busiest Day Per Branch**
   ```sql
   SELECT branch, DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%y'), '%W') AS busiest_day, COUNT(*) AS transactions
   FROM walmart
   GROUP BY branch, busiest_day
   ORDER BY transactions DESC;
   ```
4. **Total Quantity Sold Per Payment Method**
   ```sql
   SELECT payment_method, SUM(quantity) AS total_quantity
   FROM walmart
   GROUP BY payment_method;
   ```

## Insights & Business Implications
- **Most Preferred Payment Method**: Identified the most commonly used payment method and its share in transactions.
- **Store Performance**: Found which branches had the highest sales and customer satisfaction.
- **Category Trends**: Determined which product categories were most popular in different cities.
- **Peak Sales Days**: Identified the busiest shopping days for each branch to optimize inventory and staffing.

## Future Scope
- Implement **Power BI/Tableau** dashboards for visualization.
- Perform **predictive analytics** on customer buying behavior.
- Use **machine learning** to forecast sales trends.

## Conclusion
This project successfully analyzed Walmart's transactional data using Python and SQL, providing valuable business insights. The findings can help Walmart optimize its operations, inventory, and marketing strategies.

