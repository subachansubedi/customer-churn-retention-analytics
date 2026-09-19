How to Use

1. Install Requirements
Install Python and Jupyter Notebook/JupyterLab.

Then install the required Python libraries:

pip install pandas numpy matplotlib seaborn scikit-learn joblib openpyxl

2. Add the Dataset
Place Prediction_Data.xlsx inside the project's data folder.

The Excel file should contain the following sheets:

vw_ChurnData — Historical customer data used to train the model.

vw_JoinData — New customer data used for churn prediction.

3. Open the Notebook
Open:

Churn_Prediction_Random_Forest.ipynb

using Jupyter Notebook or JupyterLab.

4. Run the Notebook
Run the notebook cells from top to bottom.

The notebook will:

Preprocess the customer data.

Train the Random Forest model.

Evaluate the model.

Generate feature importance.

Predict potential churners.

Save the trained model and encoders.

5. Prediction Output
The predicted churners will be exported to:

data/Predictions.csv

6. Power BI
Import Predictions.csv into Power BI and use it to create the churn prediction dashboard.