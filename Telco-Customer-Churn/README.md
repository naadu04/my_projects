# Telco Customer Churn Analysis: Python & Power BI

## What this project is about

A telecom company wants to know one thing: **who is leaving, and why?**

In this project I used the Telco Customer Churn dataset to compare customers who left with customers who stayed. I then built a simple model that gives every customer a churn risk, and put it all into a Power BI dashboard.

## The main answer

Most customers stay, but a lot still leave.

| | Customers | Share |
|---|---|---|
| Stayed | 5,174 | 73.5% |
| Left | 1,869 | 26.5% |

About 1 in 4 customers left. Customers who left also paid more per month (median about 80 vs 64) and left early (median tenure of 10 months vs 38).

## What I found

Churn rate for the main groups:

| Group | Churn rate |
|---|---|
| Month-to-month contract | about 43% |
| One-year contract | about 11% |
| Two-year contract | about 3% |
| Fiber optic internet | about 42% |
| DSL internet | about 19% |
| Electronic check payment | about 45% |
| Automatic payments (bank transfer or card) | about 15 to 17% |
| No Tech Support | about 42% |
| With Tech Support | about 15% |
| First 12 months as a customer | about 47% |
| 49 months or more | about 10% |

## Recommendations

1. **Move month-to-month customers onto longer contracts** with a small discount or perk.
2. **Focus on the first year.** Give new customers a welcome check-in, onboarding help and an early-loyalty offer.
3. **Encourage automatic payments** instead of electronic check.
4. **Investigate fiber optic.** Customers pay more and leave more. It could be price, reliability or service, and this data can't say which.
5. **Offer Tech Support and Online Security** free for a few months to at-risk customers.

## How I built it

**1. Python (Jupyter Notebook)**
- Explored and cleaned the data: checked shape, data types, missing values and duplicates.
- Fixed `TotalCharges`, which was stored as text, using `pd.to_numeric`.
- Checked outliers in `MonthlyCharges` and `tenure` with the IQR method and z-scores.
- Made charts to compare churn across contract type, monthly charges and tenure.
- Built two models to predict churn: **Logistic Regression** and **Random Forest**, using a train/test split and a preprocessing pipeline.
- Exported a file for the dashboard with each customer's churn probability and risk level (Low, Medium, High).

**2. Power BI**
- Loaded the exported CSV.
- Built the dashboard with: churn Yes vs No, total customers, churn rate, churn rate by contract, internet service, payment method and tenure, customers by risk level, a list of the highest-risk customers, and slicers for contract and risk level.

## Model results

Tested on 20% of the data that the model had not seen:

| Model | Accuracy | Precision | Recall | F1 | ROC AUC |
|---|---|---|---|---|---|
| Logistic Regression | 0.738 | 0.504 | 0.783 | 0.614 | 0.841 |
| Random Forest | 0.781 | 0.617 | 0.465 | 0.530 | 0.822 |

I chose **Logistic Regression** for the dashboard. Random Forest has higher accuracy, but it only catches about 47% of customers who actually leave. Logistic Regression catches about 78%. For churn, missing a customer who is about to leave costs more than a false alarm.

## Dashboard

*Add a screenshot of your dashboard here, for example:*

`![Dashboard](dashboard.png)`

## Limitations

- The patterns show which customers tend to leave, not why. For example, fiber optic customers churn more, but the data doesn't show that fiber optic itself is the cause.
- The risk level for each customer comes from a model that scored every customer, including the ones it learned from. Treat it as a ranking of who looks riskiest, not an exact prediction.
- The risk bands (Low below 0.4, Medium 0.4 to 0.7, High above 0.7) are my own choice and can be changed.
- The dataset has 7,043 customers and 21 columns.

## Files

- `telco_df_edited.ipynb`: the Python notebook (cleaning, analysis, models, export)
- `Telco-Customer-Churn.csv`: the original dataset
- `churn_dashboard_data.csv`: the file produced by the notebook and loaded into Power BI
- `Telco Churn Dashboard.pbix`: the Power BI dashboard (rename to match your saved file)

## Tools used

Python (pandas, numpy, seaborn, matplotlib, scipy, scikit-learn), Jupyter Notebook, Power BI Desktop

## How to run it

1. Put the notebook and `Telco-Customer-Churn.csv` in the same folder.
2. Open the notebook in Jupyter and run all cells from the top.
3. The last cell creates `churn_dashboard_data.csv`.
4. In Power BI, choose Get data → Text/CSV and load that file.
