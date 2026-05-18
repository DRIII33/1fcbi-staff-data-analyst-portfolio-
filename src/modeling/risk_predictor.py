
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report

def generate_lending_data(n_rows=50000):
    np.random.seed(42)
    data = {
        'loan_id': np.arange(1, n_rows + 1),
        'timestamp': pd.to_datetime('2022-01-01') + pd.to_timedelta(np.random.randint(0, 730, n_rows), unit='D'),
        'tier': np.random.choice(['A', 'B', 'C', 'D'], n_rows, p=[0.4, 0.3, 0.2, 0.1]),
        'loan_amount': np.random.uniform(10000, 1000000, n_rows),
        'collateral_value': np.random.uniform(15000, 1500000, n_rows),
        'is_military_base_outreach': np.random.choice([True, False], n_rows, p=[0.2, 0.8]),
        'interest_rate': np.random.uniform(3.0, 15.0, n_rows),
        'credit_score': np.random.randint(580, 851, n_rows)
    }

    df = pd.DataFrame(data)

    # Calculate LTV ratio
    df['ltv_ratio'] = df['loan_amount'] / df['collateral_value']
    df.loc[df['ltv_ratio'] > 1, 'ltv_ratio'] = 1.0 # Cap LTV at 1.0

    # Simulate a default event based on LTV and credit score
    # Higher LTV and lower credit score -> higher probability of default
    default_prob = (df['ltv_ratio'] * 0.4) + ((850 - df['credit_score']) / 270 * 0.3) + (np.random.rand(n_rows) * 0.3)
    df['default_event'] = (default_prob > 0.5).astype(int)

    return df

def execute_risk_tiering(df):
    # Select features and target
    features = ['loan_amount', 'credit_score', 'ltv_ratio', 'is_military_base_outreach']
    X = df[features]
    y = df['default_event']

    # Convert boolean to int for the model
    X['is_military_base_outreach'] = X['is_military_base_outreach'].astype(int)

    # Split data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

    # Initialize and train RandomForestClassifier
    model = RandomForestClassifier(n_estimators=100, max_depth=5, random_state=42)
    model.fit(X_train, y_train)

    # Make predictions
    y_pred = model.predict(X_test)

    # Evaluate the model
    print("
Model Accuracy:", accuracy_score(y_test, y_pred))
    print("
Classification Report:
", classification_report(y_test, y_pred))

    # Get feature importances
    feature_importances = pd.Series(model.feature_importances_, index=features).sort_values(ascending=False)
    print("
Feature Importances:
", feature_importances)

    return model, feature_importances

# Generate synthetic data
lending_data = generate_lending_data(n_rows=50000)

# Execute risk tiering and get feature importances
risk_model, importances = execute_risk_tiering(lending_data)

print("
Risk analysis complete. The feature importances highlight the most significant factors contributing to loan default.
")
