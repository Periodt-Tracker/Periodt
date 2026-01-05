import joblib
import matplotlib.pyplot as plt

# Load models
phase_model = joblib.load("cycle_phase_model.joblib")
hormone_models = joblib.load("hormone_models.joblib")

PHASES = phase_model.named_steps["clf"].classes_


# --- Forecast functions (same as before) ---
def forecast_hormones(cycle_day, phase_probs):
    import pandas as pd

    predictions = {}
    for hormone, model in hormone_models.items():
        hormone_estimate = 0.0
        for phase, prob in phase_probs.items():
            row = {
                "cycle_day": cycle_day,
                **{f"phase_{p}": 1 if p == phase else 0 for p in PHASES},
            }
            X = pd.DataFrame([row])
            hormone_estimate += prob * model.predict(X)[0]
        predictions[hormone] = hormone_estimate
    return predictions


def smooth_phase_probs(phase_probs, cycle_day):
    transitions = {
        "Menstrual": "Follicular",
        "Follicular": "Ovulation",
        "Ovulation": "Luteal",
        "Luteal": "Menstrual",
    }
    new_probs = phase_probs.copy()
    for phase, next_phase in transitions.items():
        new_probs[next_phase] += 0.1 * phase_probs[phase]
        new_probs[phase] *= 0.9
    total = sum(new_probs.values())
    return {k: v / total for k, v in new_probs.items()}


def forecast_cycle(start_cycle_day, cycle_length, days_ahead, initial_phase_probs):
    forecasts = []
    phase_probs = initial_phase_probs.copy()
    for day in range(days_ahead):
        cycle_day = (start_cycle_day + day - 1) % cycle_length + 1
        hormones = forecast_hormones(cycle_day, phase_probs)
        forecasts.append({"cycle_day": cycle_day, **hormones, **phase_probs})
        phase_probs = smooth_phase_probs(phase_probs, cycle_day)
    return forecasts


# --- 1. Fake initial probabilities ---
initial_phase_probs = {
    "Menstrual": 0.7,
    "Follicular": 0.2,
    "Ovulation": 0.05,
    "Luteal": 0.05,
}

forecasted = forecast_cycle(
    start_cycle_day=1,
    cycle_length=28,
    days_ahead=28,
    initial_phase_probs=initial_phase_probs,
)

# --- 3. Extract hormone values ---
days = [d["cycle_day"] for d in forecasted]
lh = [d["lh"] for d in forecasted]
estrogen = [d["estrogen"] for d in forecasted]
pdg = [d["pdg"] for d in forecasted]

# --- 4. Determine dominant phase per day ---
dominant_phase = [max(d, key=lambda k: d[k] if k in PHASES else -1) for d in forecasted]

# Map phases to colors
phase_colors = {
    "Menstrual": "#FFC1C1",  # light red
    "Follicular": "#C1FFC1",  # light green
    "Ovulation": "#C1C1FF",  # light blue
    "Luteal": "#FFFAC1",  # light yellow
}

# --- 5. Plot ---
plt.figure(figsize=(12, 6))

# Background shading for phases
for i, phase in enumerate(dominant_phase):
    plt.axvspan(
        days[i] - 0.5,
        days[i] + 0.5,
        color=phase_colors.get(phase, "#FFFFFF"),
        alpha=0.3,
    )

# Hormone curves
plt.plot(days, lh, label="LH", marker="o")
plt.plot(days, estrogen, label="Estrogen", marker="o")
plt.plot(days, pdg, label="Progesterone (PdG)", marker="o")

plt.xlabel("Cycle Day")
plt.ylabel("Hormone Level")
plt.title("Forecasted Hormone Levels Across One Cycle")
plt.legend()
plt.grid(True)
plt.show()
