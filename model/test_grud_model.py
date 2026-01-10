# test_grud_model.py
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import torch


# ----------------------------
# 1. GRU-D Cell & Model
# (Same as training definition, required for loading TorchScript)
# ----------------------------
class GRUDCell(torch.nn.Module):
    def __init__(self, input_size, hidden_size):
        super().__init__()
        self.input_size = input_size
        self.hidden_size = hidden_size
        self.z_gate = torch.nn.Linear(input_size * 2 + hidden_size, hidden_size)
        self.r_gate = torch.nn.Linear(input_size * 2 + hidden_size, hidden_size)
        self.h_hat = torch.nn.Linear(input_size * 2 + hidden_size, hidden_size)
        self.gamma_x = torch.nn.Parameter(torch.randn(input_size))
        self.gamma_h = torch.nn.Parameter(torch.randn(hidden_size))

    def forward(self, x, x_last, h_prev, delta, mask):
        gamma_x = torch.exp(-torch.relu(self.gamma_x) * delta)
        x_hat = mask * x + (1 - mask) * (gamma_x * x_last + (1 - gamma_x) * 0.0)
        gamma_h = torch.exp(-torch.relu(self.gamma_h) * delta)
        h_prev = gamma_h * h_prev
        z = torch.sigmoid(self.z_gate(torch.cat([x_hat, mask, h_prev], dim=-1)))
        r = torch.sigmoid(self.r_gate(torch.cat([x_hat, mask, h_prev], dim=-1)))
        h_tilde = torch.tanh(self.h_hat(torch.cat([x_hat, mask, r * h_prev], dim=-1)))
        h = (1 - z) * h_prev + z * h_tilde
        return h, x_hat


class GRUD(torch.nn.Module):
    def __init__(self, input_dim, hidden_dim=64, phase_classes=4):
        super().__init__()
        self.hidden_dim = hidden_dim
        self.phase_classes = phase_classes
        self.cell = GRUDCell(input_dim, hidden_dim)
        self.phase_head = torch.nn.Linear(hidden_dim, phase_classes)
        self.lh_head = torch.nn.Linear(hidden_dim, 1)
        self.estrogen_head = torch.nn.Linear(hidden_dim, 1)
        self.pdg_head = torch.nn.Linear(hidden_dim, 1)

    def forward(self, x, mask, delta):
        batch, seq_len, feature_dim = x.size()
        h = torch.zeros(batch, self.hidden_dim)
        x_last = torch.zeros_like(x[:, 0, :])
        outputs = []
        for t in range(seq_len):
            h, x_last = self.cell(x[:, t, :], x_last, h, delta[:, t, :], mask[:, t, :])
            outputs.append(h.unsqueeze(1))
        h_seq = torch.cat(outputs, dim=1)
        phase_logits = self.phase_head(h_seq)
        lh_pred = self.lh_head(h_seq).squeeze(-1)
        estrogen_pred = self.estrogen_head(h_seq).squeeze(-1)
        pdg_pred = self.pdg_head(h_seq).squeeze(-1)
        return phase_logits, lh_pred, estrogen_pred, pdg_pred


# ----------------------------
# 2. Preprocess user data
# ----------------------------
def preprocess_user_data(csv_path, feature_cols):
    df = pd.read_csv(csv_path)
    x = df[feature_cols].values.astype(np.float32)
    mask = (~np.isnan(x)).astype(np.float32)
    x[np.isnan(x)] = 0.0

    # Compute delta (time since last observation per feature)
    delta = np.zeros_like(x)
    last_obs = np.zeros(x.shape[1])
    for t in range(x.shape[0]):
        delta[t, :] = np.where(mask[t, :] == 1, 0, 1 + delta[t - 1, :])
        last_obs = np.where(mask[t, :] == 1, x[t, :], last_obs)
    return x, mask, delta, df["day_in_study"].values


# ----------------------------
# 3. Test and plot
# ----------------------------
def test_and_plot(model_path, csv_path):
    # Load user data
    df = pd.read_csv(csv_path)
    feature_cols = [
        c
        for c in df.columns
        if c not in ["day_in_study", "phase", "lh", "estrogen", "pdg"]
    ]
    x, mask, delta, days = preprocess_user_data(csv_path, feature_cols)

    # Convert to tensors
    x_tensor = torch.tensor(x).unsqueeze(0)  # [1, seq_len, feature_dim]
    mask_tensor = torch.tensor(mask).unsqueeze(0)
    delta_tensor = torch.tensor(delta).unsqueeze(0)

    # Load TorchScript GRU-D model
    model = torch.jit.load(model_path)
    model.eval()

    # Predict
    with torch.no_grad():
        phase_logits, lh_pred, est_pred, pdg_pred = model(
            x_tensor, mask_tensor, delta_tensor
        )

    phase_probs = torch.softmax(phase_logits, dim=-1).squeeze(0).numpy()
    lh_pred = lh_pred.squeeze(0).numpy()
    est_pred = est_pred.squeeze(0).numpy()
    pdg_pred = pdg_pred.squeeze(0).numpy()

    # Mask fully missing days
    no_data_days = mask.sum(axis=1) == 0
    phase_probs[no_data_days, :] = np.nan
    lh_pred[no_data_days] = np.nan
    est_pred[no_data_days] = np.nan
    pdg_pred[no_data_days] = np.nan

    # ----------------------------
    # Plot Phase Probabilities
    # ----------------------------
    phase_names = ["Menses", "Follicular", "Ovulation", "Luteal"]
    plt.figure(figsize=(12, 5))
    for i, p in enumerate(phase_names):
        plt.plot(days, phase_probs[:, i], label=p)
    plt.xlabel("Day in Study")
    plt.ylabel("Phase Probability")
    plt.title("Predicted Phase Probabilities")
    plt.legend()
    plt.grid(True)
    plt.show()

    # ----------------------------
    # Plot Hormone Predictions
    # ----------------------------
    plt.figure(figsize=(12, 5))
    plt.plot(days, lh_pred, label="LH")
    plt.plot(days, est_pred, label="Estrogen")
    plt.plot(days, pdg_pred, label="PDG")
    plt.xlabel("Day in Study")
    plt.ylabel("Hormone Level")
    plt.title("Predicted Hormone Levels")
    plt.legend()
    plt.grid(True)
    plt.show()


# ----------------------------
# 4. Run demo
# ----------------------------
if __name__ == "__main__":
    test_and_plot("gru_d_model.pt", "user_last_90_days.csv")
