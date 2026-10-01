# SwiftTech Employee Data — Excel to Power Query

A data cleaning project that takes raw SwiftTech employee records, tidies them up in Excel, and loads them through Power Query to produce an analysis-ready table.

## What this is

This workbook has two tabs that represent two stages of the same dataset:

| Tab | Table name | What it holds |
|---|---|---|
| `Sheet1` | `Swifttech_data` | The raw/manually cleaned data — turned into a proper Excel Table, but still has messy fields (inconsistent dates, combined location field, blank genders) |
| `Swifttech_data` | `Swifttech_data_1` | The Power Query output — same 276 employee records, reshaped into a clean, analysis-ready table |

## Raw data (`Sheet1` → `Swifttech_data` table)

Columns: `Emp ID`, `Name`, `Gender`, `Department`, `Salary`, `Start Date`, `FTE`, `Work location`

Known issues in this version:
- `Start Date` is a mix of formats — e.g. `12-Nov-18`, `Mar 5, 2018`, and raw Excel serial numbers like `43710`
- `Work location` combines city and country into one text field (e.g. `Seattle, USA`), except for remote staff, which is just `Remote`
- Some `Name` values have leading/trailing whitespace
- Some `Gender` values are blank
- `Department` has a literal text value `"NULL"` for some rows rather than a true blank

## Power Query transformations

Loading `Swifttech_data` into Power Query and comparing it against the raw table shows the following steps were applied:

1. **Standardized `Start Date`** — all the different date formats and serial numbers were converted into one consistent date type.
2. **Split `Work location` into `City` and `Country`** — split on the comma; `Remote` rows became `City = Remote`, `Country = Remote` so no rows were lost to blanks.
3. **Trimmed whitespace** from `Name` values.
4. **Filled blank `Gender`** values with `"Unspecified"` instead of leaving them empty.
5. **Derived a `PT/FT` column from `FTE`** — employees with `FTE = 1` are labeled `Full time`; everyone with `FTE < 1` (0.2–0.9) is labeled `Part time`.
6. **Reordered columns** so `FTE` moves to the end, after the new `City`, `Country`, and `PT/FT` columns.

Note: the `"NULL"` text value in `Department` was carried through unchanged — it wasn't converted to a true blank or filled in this version.

## Output schema (`Swifttech_data_1`)

| Column | Type | Notes |
|---|---|---|
| Emp ID | Text | Unique employee ID |
| Name | Text | Trimmed |
| Gender | Text | `Male`, `Female`, or `Unspecified` |
| Department | Text | Includes literal `"NULL"` for unassigned rows |
| Salary | Number | |
| Start Date | Date | Standardized |
| City | Text | e.g. `Seattle`, `Hyderabad`, `Remote` |
| Country | Text | e.g. `USA`, `India`, `New Zealand`, `Remote` |
| PT/FT | Text | Derived from FTE |
| FTE | Number | 0.2–1.0 |

**Row count:** 276 employee records (plus header)

## How to use this

1. Open `SwiftTeckEmpData.xlsx` in Excel.
2. The raw table lives on `Sheet1`.
3. The cleaned/query output lives on the `Swifttech_data` tab — right-click it and choose **Edit Query** (or go to **Data → Queries & Connections**) to see and modify the actual Power Query steps.
4. To refresh after updating the raw table, use **Data → Refresh All**.

## Possible next steps

- Convert the literal `"NULL"` text in `Department` into a real blank or an `"Unassigned"` label, consistent with how `Gender` was handled
- Standardize whitespace on `Country` (currently has a leading space, e.g. `" USA"`)
- Add a calculated column for tenure (years since `Start Date`)
