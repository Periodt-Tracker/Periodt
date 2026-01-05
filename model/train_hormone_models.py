import joblib
import numpy as np
import pandas as pd
from sklearn.ensemble import HistGradientBoostingRegressor

# ---------------------------
# Load data
# ---------------------------
df = pd.read_csv("./data/mcphases/hormones_and_selfreport.csv")

df = df.dropna(subset=["phase", "day_in_study"])

HORMONES = ["lh", "estrogen", "pdg"]

# Normalize day-in-cycle per participant
df["cycle_day"] = df.groupby("id")["day_in_study"].rank(method="dense")

models = {}

for hormone in HORMONES:
    hormone_df = df.dropna(subset=[hormone])

    X = hormone_df[["cycle_day", "phase"]]
    y = hormone_df[hormone]

    # Encode phase numerically
    X = pd.get_dummies(X, columns=["phase"])

    model = HistGradientBoostingRegressor(max_depth=5, learning_rate=0.05, max_iter=300)

    model.fit(X, y)
    models[hormone] = model

joblib.dump(models, "hormone_models.joblib")
print("✅ Hormone models trained")
