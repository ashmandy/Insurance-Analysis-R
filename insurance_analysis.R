
--- 
title: "Insurance Cost Analysis:"
author: "Mandy Langlois"
---
 
# Load Library
library(tidyverse)
library(caret)
library(ggplot2)

#Load Data
insurance = read_csv("insurance.csv")


# Data Validation/Exploration:

# View first rows 
head(insurance)

# Dataset structure check
glimpse(insurance)

# Summary statistic for each column 
summary(insurance)

# check for missing values in each column 
colSums(is.na(insurance))

# Data Cleaning:


# Convert categorical columns into factors
# a s.factors: turns character strings into categorical variables(factors)

insurance = insurance |>
  mutate(
    sex = as.factor(sex),
    smoker = as.factor(smoker),
    region = as.factor(region)
  )

# Creating grouped version of BMI and age
# Creating a simple risk flag based on smoking + BMI

insurance = insurance |>
 mutate(
  bmi_group = case_when(
    bmi < 18.5 ~ "Underweight",
    bmi < 25 ~ "Normal",
    bmi < 30 ~ "Overweight",
    TRUE ~ "Obese"
  ),
bmi_group = factor(
  bmi_group,
  levels = c("Underweight","Normal","Overweight","Obese")
),
age_group = case_when(
  age < 30 ~ "18-29",
  age < 25 ~ "30-40",
  age < 30 ~ "45-59",
  TRUE ~"60+"
),
age_group = factor(
  age_group,
  levels = c("18-29","30-40","45-59","60+")
),
 high_risk_flag = case_when(
   smoker == "yes" & bmi >= 30 ~ "High Risk",
   smoker == "yes" ~ "Elevated Risk",
   bmi >= 30 ~ "moderate Risk",
   TRUE ~ "Standard Risk"
 ),
high_risk_flag = as.factor(high_risk_flag)
)


# Exploratory Analysis:
    
# Distribution of charges   
  ggplot(insurance,aes(charges)) +
  geom_histogram(bins=30, fill="orange", color="white")+
  labs(
    title = "The Distribution of Insurance Charges",
    x = "Smoking Status",
    y = "Insurance Charge")


# Charges by smoking status
ggplot(insurance,aes(x=smoker, y= charges, fill = smoker)) +
  geom_boxplot()+
  labs("Charges by Smoking Status")

# Charge by BMI group 
ggplot(insurance, aes(x = bmi_group, y = charges, fill = bmi_group)) +
  geom_boxplot() +
  labs(
    title = "Charges by BMI Group",
    x = "BMI Group",
    y = "Insurance Charges"
  )

# Charges by age group
ggplot( insurance, aes(x = age_group, y = charges, fill = age_group)) +
  geom_boxplot() +
  labs(
    title = "Charges by Age Group",
    x = "Age Group",
    y = "Insurance Charges"
  )
  
# Average charges by risk categories 
risk_summary = insurance |>
  group_by(high_risk_flag) |>
  summarise(
    avg_charges = mean(charges),
    median_charges = median(charges),
    members = n(),
    .group = "drop"
  )
 print(risk_summary)


#Correlation Analysis:

insurance|>
  select(age, bmi, children, charges)|>
  cor()|>
  round(2)


# Train/ test split:

#train contains 80% of data. 
# test contains 20% of the data. 
set.seed(123)

train_index = createDataPartition(insurance$charges, p= 0.8, list = FALSE) 
train = insurance [train_index,]
test = insurance[-train_index,]


# Baseline model:

# First model: linear regression
lm_baseline = lm(
  charges ~ age + bmi + children + smoker + region + sex,
  data = train
)

# Checking whether BMI and age behave differently for smokers
lm_interaction = lm(
  charges ~ age + bmi + children + smoker + region + sex + bmi:smoker + age:smoker,
  data = train 
)

summary(lm_interaction)


# Predictions:

# Using both models to predict charges on the test set
baseline_preds = predict(lm_baseline, newdata = test)
interaction_preds = predict(lm_interaction, newdata = test)


# Model evaluation:

RMSE = function(actual, predicted) {
  sqrt(mean((actual - predicted)^2))
}

MAE = function(actual, predicted) {
  mean(abs(actual - predicted))
}

r_squared = function(actual, predicted) {
  cor(actual, predicted)^2
}


# Comparing model performance
model_results = tibble(
  model = c( "Baseline LM", "Interaction LM"),
  RMSE = c (
    RMSE(test$charges, baseline_preds), 
    RMSE (test$charges, interaction_preds)
  ),
  MAE = c(
    MAE(test$charges, baseline_preds),
    MAE (test$charges, interaction_preds)
  ),
  R_Squared = c(
    r_squared(test$charges, baseline_preds),
    r_squared (test$charges, interaction_preds)
 )
  )
 print (model_results)
 
 
 # Actual vs Predicted results:
 
 # Keeping results from the better model using the interaction model 
 results = test|>
   mutate(
     predicted = interaction_preds,
     residual = charges - predicted,
     abs_error = abs(residual)
   )
 head(model_results)

 # Actual vs predicted plot
 ggplot(results, aes(x = charges, y = predicted)) +
   geom_point(alpha = 0.6) +
   geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
   labs(
     title = "Actual vs Predicted Insurance Charges",
     x = "Actual Charges",
     y = "Predicted Charges"
   )

 # Error by risk group
 error_by_risk = results |>
   group_by(high_risk_flag) |>
   summarise(
     mean_abs_error = mean(abs_error),
     avg_actual = mean(charges),
     members = n(),
     .group = "drop"
   )


 # Final summary:
segment_summary = insurance |>
  group_by(high_risk_flag) |>
  summarise(
    avg_charges = mean(charges),
    median_charges = median(charges),
    total_charges = sum(charges),
    members = n(),
    .group = "drops"
  ) |>
  arrange(desc(avg_charges))

print(segment_summary)

 
 
 
 # Creating a visuals folder 
dir.create("visuals")

