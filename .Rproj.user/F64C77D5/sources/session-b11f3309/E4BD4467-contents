
--- 
title: "Insurance Cost Analysis:"
author: "Mandy Langlois"
---
 
  # Loading Library.
  library(tidyverse) 
  library(caret)
  library(ggplot2)



insurance = read_csv("insurance.csv")

# Data Validation 
head(insurance)

# Data Exploration
glimpse(insurance)

summary(insurance)

# Data cleaning 
# finding NA values
colSums(is.na(insurance))

# Converting categorical variables into factors
#a s.factors: turns character strings into categorical variables(factors)

insurance = insurance |>
  mutate(
    age = as.factor(age),
    sex = as.factor(sex),
    region = as.factor(region)
  )


# Exploratory Analysis:
    
  # Distribution of charges   
  
ggplot(insurance,aes(charges)) +
  geom_histogram(bins=30, fill="orange", color="white")+
  labs(title = "The Distribution of Charges")


# Charges by smoking status

ggplot(insurance,aes(x=smoker, y= charges, fill = smoker)) +
  geom_boxplot()+
  labs("Charges by Smoking Status")
  
#Correlation Analysis:

# Analysis: Correlation values ranges from -1 to 1. Ranges 0.7-1.0 is a strong positive correlation,
# 0.4-0.69 is moderate positive,0.1 to 0.39 is a weak positive,  0.o to 0.09 shows no correlation,
# and -0.1 to -1.0 is a negative correlation. Knowing what we know about correlation values ranges,
# the output suggest that at 0.01 there's no correlation between people's BMI and the number of children.
# At a.20 there is a weak, but positive relationship between BMI and charges, charges tend to increase as BMI increase.
# with a correlation range of 0.07,very weak positive, more children is slightly associated with higher charges but 
# the effects are so small that its almost meaningless.

insurance|>
  select_if(is.numeric)|>
  cor()|>
  round(2)

# Building Predictive Models:

# training test split 
# Coefficients( effect size for each variable),
# p-values(significance),
# R-squared(how much variance explained)

#train contains 80% of data. use to train the model.
# test contains 20%. used to evaluate model performance later.

set.seed(123)
train_index = createDataPartition(insurance$charges, p= 0.8, list = FALSE) # creates index for 80% training data.
train =insurance [train_index,] #splits into training and testing sets 
train =insurance[-train_index,]
# Predicting charges based on age, BMI,Children, smoker, region,sex.
# the median being close to zero indicate that the model isnt over or under predicting.
# The large min(-12663) and max(17646) indicates that outliers exist.Very low or high charges.
# *** -> highly significant (p<0.0001)
# ** -> significant (p<0.01)
# * -> moderately significant (p<0.1)
# .-> not significant 

# Analysis: Smokers are the biggest cost drivers, they add about $21,000 more.
# BMI: higher BMI results in higher charges.
# Children: Slightly higher charges with more children.
# Age: Some ages show significance difference. People in their 30s-60 pay higher charges.
# region/sex: aren't a significant predictor.
# Model accuracy: 79% of cost differences.
# Error: typical prediction error = $6,000.
model = lm(charges ~ age + bmi + children+ smoker + region + sex, data = train)
summary(model)

library(caret)

set.seed(123)

train_index = createDataPartition(insurance$charges, p=0.8,list = FALSE)

train=insurance[train_index,]
test=insurance[-train_index,]

# Model evaluation
#simulating predictive charges for smokers vs non-smoker.
# RMSE: RMSE: 5342.639,my model predictions are off by about $5,343 from the actual insurance charge.
# the smaller the rmse the better. I can try to reduce the rmse by adding interaction terms like smokers with 
# a high BMI might behave differently.
predictions = predict(model,newdata= test)
RMSE =sqrt(mean((predictions-test$charges)^2))
cat("RMSE:", RMSE,"\n")

