# NY Housing Price Prediction

A simple linear regression project that predicts New York housing prices using three features: number of beds, number of baths, and property square footage.

## What this is

This notebook explores a dataset of NY property listings, cleans it up, and trains a Linear Regression model to predict `PRICE` from `BEDS`, `BATH`, and `PROPERTYSQFT`. It's a learning exercise in the full basic workflow: explore → clean → visualize → train → evaluate.

## Dataset

- **File:** `NY_Housing.csv` (not included in this repo — add your own copy locally)
- **Original size:** 4,801 rows × 17 columns
- **After cleaning:** 4,587 rows × 17 columns

Columns include broker info, listing type, price, beds, bath, square footage, and address/location details (state, locality, sublocality, lat/long).

## What was done

### 1. Understanding the data
Checked shape, data types, summary stats, and missing values with `.head()`, `.describe()`, `.info()`, and `.isnull().sum()`.

### 2. Initial visualization
- Histogram of price distribution
- Line chart of average price by number of beds
- Scatter plot of square footage vs. price
- Bar chart of average square footage by property type

### 3. Data preparation
- Dropped duplicate rows (4,801 → 4,587)
- Capped outliers in `PRICE`, `BEDS`, `BATH`, and `PROPERTYSQFT` using the IQR method (values outside the bounds get pulled to the bounds instead of being deleted, so no rows are lost)
- Replaced `0` values in `BATH` with the column median
- Replaced a repeated placeholder/imputed value in `PROPERTYSQFT` with the real median
- Flagged non-active listings (Pending, Contingent, Coming Soon) in a new `IS_ACTIVE` column, in case someone wants to filter them out later

### 4. Model training
- **Target:** `PRICE`
- **Features:** `BEDS`, `BATH`, `PROPERTYSQFT`
- Split into 80% train (3,669 rows) / 20% test (918 rows)
- Features were scaled with `StandardScaler` (though the final model shown was fit on the unscaled `X_train` — worth double-checking which version you want to use if you build on this)
- Model: `sklearn.linear_model.LinearRegression`

**Resulting equation:**
```
PRICE = -61,499.80 + (-59,375.33 × BEDS) + (313,385.21 × BATH) + (399.77 × PROPERTYSQFT)
```

### 5. Prediction example
For a 5-bed, 5-bath, 350 sqft property, the model predicts a price of about **$1,348,468**.

### 6. Performance evaluation
| Metric | Value |
|---|---|
| R² | 0.4520 |
| RMSE | $654,449.06 |

**What this means:** the model explains less than half the variation in price. Beds, baths, and square footage alone aren't enough to really nail down NYC prices — things like location, floor level, building age, and amenities matter a lot too, and none of those are in this model. The RMSE is also large relative to the price range (about $49K–$2.99M after capping), so predictions should be treated as rough estimates, not precise figures.

## Requirements

```
pandas
numpy
matplotlib
seaborn
scikit-learn
```

Install with:
```bash
pip install pandas numpy matplotlib seaborn scikit-learn
```

## Running it

1. Place `NY_Housing.csv` in the same folder as the notebook (or update the file path in the second cell).
2. Open `NY_Housing_Data.ipynb` in Jupyter.
3. Run all cells top to bottom.

## Possible next steps

- Add location-based features (locality, sublocality, or lat/long) to see if they improve R²
- Try Ridge or Lasso regression to handle any correlated features
- Cross-validate instead of a single train/test split
- Confirm whether scaled or unscaled features should be used for the final model fit
