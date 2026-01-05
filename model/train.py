import joblib
import numpy as np
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OrdinalEncoder, StandardScaler

# ---------------------------
# 1. Load data
# ---------------------------
df = pd.read_csv("./data/mcphases/hormones_and_selfreport.csv")

# Drop rows without target
df = df.dropna(subset=["phase"])

# ---------------------------
# 2. Likert normalization
# ---------------------------
LIKERT_MAP = {
    "Not at all": 0,
    "Very Low/Little": 1,
    "Very Low": 1,
    "Low": 2,
    "Moderate": 3,
    "High": 4,
    "Very High": 5,
}

SYMPTOM_COLUMNS = [
    "appetite",
    "exerciselevel",
    "headaches",
    "cramps",
    "sorebreasts",
    "fatigue",
    "sleepissue",
    "moodswing",
    "stress",
    "foodcravings",
    "indigestion",
    "bloating",
]

for col in SYMPTOM_COLUMNS:
    if col in df.columns:
        df[col] = df[col].map(LIKERT_MAP)

# ---------------------------
# 3. Feature sets
# ---------------------------
NUMERIC_FEATURES = [
    "lh",
    "estrogen",
    "pdg",
] + SYMPTOM_COLUMNS

CATEGORICAL_FEATURES = ["flow_volume", "flow_color"]

X = df[NUMERIC_FEATURES + CATEGORICAL_FEATURES]
y = df["phase"]

# ---------------------------
# 4. Preprocessing
# ---------------------------
numeric_pipeline = Pipeline(
    steps=[("imputer", SimpleImputer(strategy="median")), ("scaler", StandardScaler())]
)

categorical_pipeline = Pipeline(
    steps=[
        ("imputer", SimpleImputer(strategy="most_frequent")),
        (
            "encoder",
            OrdinalEncoder(handle_unknown="use_encoded_value", unknown_value=-1),
        ),
    ]
)

preprocessor = ColumnTransformer(
    transformers=[
        ("num", numeric_pipeline, NUMERIC_FEATURES),
        ("cat", categorical_pipeline, CATEGORICAL_FEATURES),
    ]
)

# ---------------------------
# 5. Model
# ---------------------------
model = Pipeline(
    steps=[
        ("preprocess", preprocessor),
        ("clf", LogisticRegression(solver="lbfgs", max_iter=2000)),
    ]
)

# ---------------------------
# 6. Train/test split
# ---------------------------
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# ---------------------------
# 7. Train
# ---------------------------
model.fit(X_train, y_train)

# ---------------------------
# 8. Evaluate
# ---------------------------
y_pred = model.predict(X_test)
print(classification_report(y_test, y_pred))

# ---------------------------
# 9. Save model
# ---------------------------
joblib.dump(model, "cycle_phase_model.joblib")
print("✅ Model trained and saved")
