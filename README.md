# Medical Insurance Charges Analysis — R

## Project Overview
This project analyzes a medical insurance dataset to identify the key factors 
that drive insurance charges, segment policyholders by risk level, and build 
predictive models to estimate individual charges. The analysis was completed 
entirely in R using the tidyverse ecosystem.

---

## Dataset
- **Source:** Kaggle
- **Size:** 1,338 rows × 7 columns
- **Features:** Age, sex, BMI, number of children, smoking status, region, 
and insurance charges
- **Missing Values:** None — dataset was clean upon import

---

## Objectives
1. Explore the distribution of insurance charges and identify key cost drivers
2. Segment policyholders by BMI group, age group, and risk level
3. Analyze the relationship between numeric variables and charges
4. Build and compare linear regression models to predict insurance charges
5. Evaluate model performance by risk segment

---

## Tools & Packages
| Package | Purpose |
|---------|---------|
| `tidyverse` | Data manipulation and visualization |
| `ggplot2` | Data visualization |
| `dplyr` | Data wrangling |
| `caret` | Model training and evaluation |
| `lubridate` | Date handling |

---

## Feature Engineering
Three new variables were created to enrich the analysis:

**BMI Group** — policyholders classified into:
- Underweight (BMI < 18.5)
- Normal (18.5 – 24.9)
- Overweight (25 – 29.9)
- Obese (BMI ≥ 30)

**Age Group** — policyholders grouped into:
- 18–29, 30–44, 45–59, 60+

**Risk Flag** — policyholders segmented into four risk tiers:
- High Risk — smoker with BMI ≥ 30
- Elevated Risk — smoker with BMI < 30
- Moderate Risk — non-smoker with BMI ≥ 30
- Standard Risk — non-smoker with BMI < 30

---

## Key Findings

### Cost Drivers
- **Smoking status** is the single strongest driver of insurance charges
- **BMI** compounds the effect of smoking significantly — smokers with high 
BMI face dramatically higher charges than smokers with normal BMI
- **Age** shows a moderate positive correlation with charges (r = 0.30)
- **Number of children** and **sex** had minimal impact on charges

### Risk Segment Analysis
| Risk Segment | Avg Charges | Median Charges | Members |
|---|---|---|---|
| High Risk | $41,558 | $40,904 | 145 |
| Elevated Risk | $21,363 | $20,167 | 129 |
| Moderate Risk | $8,843 | $8,076 | 562 |
| Standard Risk | $7,977 | $6,762 | 502 |

High Risk policyholders pay on average **5.2x more** than Standard Risk 
policyholders, highlighting smoking and obesity as the dominant cost factors.

### Correlation Analysis
| Variable | Correlation with Charges |
|---|---|
| Age | 0.30 |
| BMI | 0.20 |
| Children | 0.07 |

---

## Modeling

Two linear regression models were built and evaluated on a held-out test set 
(20% of data):

**Baseline Model** — charges predicted by age, BMI, children, smoker, 
region, and sex

**Interaction Model** — adds interaction terms `bmi:smoker` and `age:smoker` 
to capture the compounding effect of smoking and BMI

### Model Performance
| Model | RMSE | MAE | R² |
|---|---|---|---|
| Baseline LM | $6,290 | $4,185 | 0.713 |
| Interaction LM | $5,128 | $2,977 | 0.810 |

The interaction model outperformed the baseline across all metrics, reducing 
MAE by **$1,208** and improving R² from 0.713 to 0.810. The `bmi:smoker` 
interaction term was the strongest predictor in the model (p < 2e-16).

---

## Visualizations
- Distribution of insurance charges (histogram)
- Charges by smoking status (box plot)
- Charges by BMI group (box plot)
- Charges by age group (box plot)
- Actual vs predicted charges scatter plot

---

## Files
| File | Description |
|------|-------------|
| `insurance_analysis.R` | Full R script including data cleaning, EDA, 
feature engineering, modeling, and evaluation |
| `insurance.csv` | Source dataset (via Kaggle) |

---

## Notes
The age group binning logic in the current script contains overlapping 
conditions that result in all ages under 45 being classified as 18–29. 
This is a known issue and will be corrected in a future update.

---

## Author
**Mandy Langlois**
Aspiring Data Analyst | Google Data Analytics Certificate(2026)
