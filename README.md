# TSK-Classification-Regression

Fuzzy theory finds its application to deal with problems where there is imprecision caused by the absence of sharp criteria. Linguistic terms can be defined by fuzzy sets and we can formulize fuzzy if-then rules. Operators like AND and OR and the implication IF ... THEN are defined and so we can somehow calculate with statements given in this form. In this repository, we estimate classification and regression problems through TSK models.

# Classification

## First part
In this part of the problem, we have used [Haberman's Survival DataSet](https://github.com/georgios-kalomitsinis/TSK-Classification-Regression/blob/main/datasets/haberman.data) available on [UCI Machine Learning Reposiroty](https://archive.ics.uci.edu/ml/datasets/haberman%27s+survival). In specific this dataset consists of:

* Age of patient at time of operation (numerical)
* Patient's year of operation (year - 1900, numerical)
* Number of positive axillary nodes detected (numerical)
* Survival status (class attribute)
  * 1 = the patient survived 5 years or longer
  * 2 = the patient died within 5 year


Furthermore, the data were separated by the Subtractive Clustering (SC) method, in the first case for all the data of the training set (class independent), and in the second case the SC will be executed in each class separately (class dependent). The number of rules is depends on the determined radius we set it as well as the squash factor. The lower the squash factor, the lower the chance of including outliers within a cluster. Finally, the evaluation metrics of the developed models are 

* Overall Accuracy (OA)
* Producer’s Accuracy (PA)
* User’s Accuracy (UA),
* Confusion matrix. 

Afterwards, for each model the corresponding FIS is generated through the SC options, as well as the corresponding diagrams of the constant Membership Functions (MFs). The next step concerns about the tuning of the FIS. As final step, the diagrams containing the learning curve, prediction error and the four metrics used for the tuning of the FIS are produced for which the validation error is minimal. 

## Second Part

A highly complex dataset based on 179 features is implemented for each of the 11500 samples. In specific, we have used the [Epileptic Seizure Recognition Data Set], available on [UCI Machine Learning Reposiroty](https://archive.ics.uci.edu/ml/datasets/Epileptic+Seizure+Recognition#). Therefore a lot of computing power is required for the production / training of the models, ie the solution of the problem through a fuzzy neural network. For the above reason, a grid search is performed to find the optimal value of the radius of the clusters as well as the number of features to be investigated (we ended up to 4 features). 

The results of the above investigations are presented [here](https://github.com/georgios-kalomitsinis/TSK-Classification-Regression/tree/main/results/classification). 

# Regression

## First part
As before, in regression task we have used 2 dtasets. the first dataset is the Airfoil Self-Noise dataset[], from [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/airfoil+self-noise), that consists of 1503 instances and 6 features. More specific:

* Inputs:
  * Frequency, in Hertzs.
  * Angle of attack, in degrees.
  * Chord length, in meters.
  * Free-stream velocity, in meters per second.
  * Suction side displacement thickness, in meters.

* Output:
  * Scaled sound pressure level, in decibels.

## Methodology

The methodology consisnts of the following serial procedure:
1. Splitting the dataset (```60% the training set, 20% validation set and 20% testing set```)
2. TSK models training with different parameters
3. Evaluation of the models

<div align="center">
  
|Models  |           Membership Functions (MFs) |         Output |
|:---:|:---:|:---:|
TSK_model_1     |                  2                  |Singleton|
TSK_model_2     |                  3                  |Singleton|
TSK_model_3     |                  2                  |Polynomial|
TSK_model_4     |                  3                  |Polynomial|
  
</div>
<figcaption align = "center"><p align="center">Table 1. The training of the 4 TSK models.</figcaption>
</figure>


## Second Part

In this part, we used [Superconductivty dataset](https://github.com/georgios-kalomitsinis/TSK-Classification-Regression/blob/main/datasets/superconduct.csv) form (UCI Machine Learning Reporsitory](https://archive.ics.uci.edu/ml/datasets/superconductivty+data#). This dataset includes 21263 samples and each of them is described by 81 attributes. It is obvious that the size of the dataset, makes prohibiting a simple application of a TSK model. In order to deal this problem, grid search was performed to find the optimal parameters of the TSK models.

## Methodology

The methodology consisnts of the following serial procedure:
1. Splitting the dataset (```60% the training set, 20% validation set and 20% testing set```)
2. Selection of the optimal parameters:
    For the purposes of this work, we define the following parameters:
     * Number of features: The number of features for the training
     * Cluster radius: The parameter that determines the radius of influence of the clusters and consequently the number of rules that will occur. 
3. Training of the final TSK model and control of evaluate its performance in the testing set.

## Metrics

In both parts, we have calculated the values of the following metrics:

* Root Mean Squared Error (RMSE)
* Normalized Mean Squared Error (NMSE)
* Non-Dimensional Error Index (NDEI)
* R² score

The results of the above investigations regression task are presented [here](https://github.com/georgios-kalomitsinis/TSK-Classification-Regression/tree/main/Regression). 

## License
This project is licensed under the [MIT License](https://github.com/georgios-kalomitsinis/TSK-Classification-Regression/blob/main/LICENSE).












