# Melbourne Housing Data Cleaning Project

This SQL project focuses on cleaning a raw housing dataset from Melbourne, Australia, to make it more suitable for analysis. The cleaning process includes handling missing values, correcting data types, dealing with outliers, removing duplicates, and standardizing values. All operations are performed using MySQL.

## Dataset -- https://www.kaggle.com/datasets/dansbecker/melbourne-housing-snapshot/data

The dataset includes various housing-related information, such as:
- Sale dates
- Property details (address, type, price, etc.)
- Property characteristics (building area, year built, number of rooms, etc.)
- Location information (postcode, council area)

---

## Cleaning Tasks and Solutions

### 1. **Previewing the Data**
- **Function used**: `SELECT *`
- **Purpose**: Understand the structure and contents of the dataset.

### 2. **Truncating the Table**
- **Function used**: `TRUNCATE TABLE`
- **Problem solved**: Removed partially imported data that was loaded incorrectly using the data wizard.

### 3. **Date Formatting**
- **Function used**: `STR_TO_DATE()`, `ALTER TABLE`
- **Problem solved**: Converted inconsistent date formats (e.g., `DD/MM/YYYY`) into a standardized SQL `DATE` format and created a new column for the fixed values.

### 4. **Handling Missing Values (YearBuilt & BuildingArea)**
- **Functions used**: `AVG()`, `UPDATE`
- **Problem solved**: Replaced missing values (`''`) in the `yearbuilt` and `buildingarea` columns with their respective average values (1965 for year built and 146 for building area).

### 5. **Identifying and Fixing Outliers**
- **Functions used**: `MAX()`, `MIN()`, `UPDATE`
- **Problem solved**: Identified outliers in columns such as `lattitude`, `rooms`, and `landsize`. Fixed unreasonable values, such as landsize values equal to 0 or greater than 10,000, and corrected them with average values.

### 6. **Removing Invalid Data (Bedrooms)**
- **Functions used**: `DELETE`
- **Problem solved**: Deleted rows with invalid bedroom data (e.g., 0 bedrooms).

### 7. **Handling Invalid YearBuilt Values**
- **Function used**: `UPDATE`
- **Problem solved**: Replaced invalid yearbuilt values (e.g., 1196) with the average year built (1965).

### 8. **Removing Duplicates**
- **Functions used**: `ROW_NUMBER()`, `CTE (Common Table Expression)`, `DELETE`
- **Problem solved**: Removed duplicate rows by keeping only the first occurrence based on columns like `fixed_date`, `address`, `type`, and `price`.

### 9. **Dropping Unnecessary Columns**
- **Function used**: `ALTER TABLE ... DROP COLUMN`
- **Problem solved**: Dropped the `councilarea` column, which had missing values and was deemed unnecessary for further analysis.

### 10. **Correcting Data Types**
- **Function used**: `ALTER TABLE ... MODIFY`
- **Problem solved**: Corrected data types for several columns (e.g., `yearbuilt`, `buildingarea`, `propertycount`, `postcode`) to more logical types like `INT`.

---

## Final Output

The final dataset is:
- Cleaned and standardized
- Structured into more meaningful columns
- Free of duplicates and missing values
- Ready for further analysis or export to a Business Intelligence tool like Power BI or Tableau

---

## Tools Used
- **MySQL** for writing and executing SQL queries
- SQL functions: `SELECT`, `UPDATE`, `ALTER TABLE`, `JOIN`, `ROW_NUMBER()`, `CASE`, `AVG()`, `DELETE`, `CTE`, `STR_TO_DATE()`, `MAX()`, `MIN()`

---

## Author
This project was created by Anatolii Perederii, as part of my portfolio development and SQL practice.
