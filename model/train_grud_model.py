# train_grud_model.py
import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from sklearn.model_selection import GroupKFold
from sklearn.preprocessing import LabelEncoder, StandardScaler
from torch.utils.data import DataLoader, Dataset


# ----------------------------
# 1. GRU-D Cell & Model
# ----------------------------
class GRUDCell(nn.Module):
    def __init__(self, input_size, hidden_size):
        super().__init__()
        self.input_size = input_size
        self.hidden_size = hidden_size

        self.z_gate = nn.Linear(input_size * 2 + hidden_size, hidden_size)
        self.r_gate = nn.Linear(input_size * 2 + hidden_size, hidden_size)
        self.h_hat = nn.Linear(input_size * 2 + hidden_size, hidden_size)

        self.gamma_x = nn.Parameter(torch.randn(input_size))
        self.gamma_h = nn.Parameter(torch.randn(hidden_size))

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


class GRUD(nn.Module):
    def __init__(self, input_dim, hidden_dim=64, phase_classes=4):
        super().__init__()
        self.hidden_dim = hidden_dim
        self.phase_classes = phase_classes
        self.cell = GRUDCell(input_dim, hidden_dim)

        self.phase_head = nn.Linear(hidden_dim, phase_classes)
        self.lh_head = nn.Linear(hidden_dim, 1)
        self.estrogen_head = nn.Linear(hidden_dim, 1)
        self.pdg_head = nn.Linear(hidden_dim, 1)

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
# 2. Dataset
# ----------------------------
class MenstrualDataset(Dataset):
    def __init__(self, df, seq_len=90):
        self.df = df
        self.seq_len = seq_len
        self.ids = df["id"].unique()
        self.feature_cols = [
            c
            for c in df.columns
            if c not in ["id", "day_in_study", "phase", "lh", "estrogen", "pdg"]
        ]

        self.phase_encoder = LabelEncoder()
        self.df["phase_encoded"] = self.phase_encoder.fit_transform(df["phase"])

        # Standardize continuous features
        self.scaler = StandardScaler()
        self.df[self.feature_cols] = self.scaler.fit_transform(
            df[self.feature_cols].fillna(0)
        )

        # Build sequences
        self.sequences = []
        for pid in self.ids:
            user_df = df[df["id"] == pid].sort_values("day_in_study")
            features = user_df[self.feature_cols].values
            phases = user_df["phase_encoded"].values
            lh = user_df["lh"].values
            estrogen = user_df["estrogen"].values
            pdg = user_df["pdg"].values

            mask = (~np.isnan(features)).astype(float)
            features[np.isnan(features)] = 0.0
            delta = np.zeros_like(features)
            last_obs = np.zeros(features.shape[1])
            for t in range(features.shape[0]):
                delta[t, :] = np.where(mask[t, :] == 1, 0, 1 + delta[t - 1, :])
                last_obs = np.where(mask[t, :] == 1, features[t, :], last_obs)

            for i in range(len(features) - seq_len + 1):
                self.sequences.append(
                    {
                        "x": features[i : i + seq_len],
                        "mask": mask[i : i + seq_len],
                        "delta": delta[i : i + seq_len],
                        "phase": phases[i : i + seq_len],
                        "lh": lh[i : i + seq_len],
                        "estrogen": estrogen[i : i + seq_len],
                        "pdg": pdg[i : i + seq_len],
                    }
                )

    def __len__(self):
        return len(self.sequences)

    def __getitem__(self, idx):
        seq = self.sequences[idx]
        return (
            torch.tensor(seq["x"], dtype=torch.float32),
            torch.tensor(seq["mask"], dtype=torch.float32),
            torch.tensor(seq["delta"], dtype=torch.float32),
            torch.tensor(seq["phase"], dtype=torch.long),
            torch.tensor(seq["lh"], dtype=torch.float32),
            torch.tensor(seq["estrogen"], dtype=torch.float32),
            torch.tensor(seq["pdg"], dtype=torch.float32),
        )


# ----------------------------
# 3. Training
# ----------------------------
def train_grud(csv_path="daily_data.csv", seq_len=90, batch_size=16, epochs=5):
    df = pd.read_csv(csv_path)
    dataset = MenstrualDataset(df, seq_len)

    gkf = GroupKFold(n_splits=5)
    for train_idx, val_idx in gkf.split(df, groups=df["id"]):
        train_dataset = torch.utils.data.Subset(dataset, train_idx)
        val_dataset = torch.utils.data.Subset(dataset, val_idx)
        break

    train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
    val_loader = DataLoader(val_dataset, batch_size=batch_size)

    input_dim = len(dataset.feature_cols)
    phase_classes = len(dataset.phase_encoder.classes_)
    model = GRUD(input_dim=input_dim, hidden_dim=64, phase_classes=phase_classes)

    device = "cuda" if torch.cuda.is_available() else "cpu"
    model.to(device)

    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    ce_loss = nn.CrossEntropyLoss()
    mse_loss = nn.MSELoss()

    for epoch in range(epochs):
        model.train()
        total_loss = 0
        for x, mask, delta, phase, lh, est, pdg in train_loader:
            x, mask, delta, phase, lh, est, pdg = (
                x.to(device),
                mask.to(device),
                delta.to(device),
                phase.to(device),
                lh.to(device),
                est.to(device),
                pdg.to(device),
            )
            optimizer.zero_grad()
            phase_logits, lh_pred, est_pred, pdg_pred = model(x, mask, delta)
            loss_phase = ce_loss(phase_logits.view(-1, phase_classes), phase.view(-1))
            loss_lh = mse_loss(lh_pred, lh)
            loss_est = mse_loss(est_pred, est)
            loss_pdg = mse_loss(pdg_pred, pdg)
            loss = loss_phase + loss_lh + loss_est + loss_pdg
            loss.backward()
            optimizer.step()
            total_loss += loss.item()
        print(
            f"Epoch {epoch+1}/{epochs} - Train Loss: {total_loss/len(train_loader):.4f}"
        )

    # Save model as TorchScript for mobile
    example_input = torch.randn(1, seq_len, input_dim)
    example_mask = torch.ones_like(example_input)
    example_delta = torch.ones_like(example_input)
    traced_model = torch.jit.trace(
        model.cpu(), (example_input, example_mask, example_delta)
    )
    traced_model.save("gru_d_model.pt")
    print("Model saved as gru_d_model.pt")


if __name__ == "__main__":
    train_grud()
