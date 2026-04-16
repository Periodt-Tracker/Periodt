/// Truncated Gaussian duration parameters for each cycle phase.
/// Maps state index → {mu, sigma}.
const Map<int, Map<String, double>> durationParams = {
  0: {'mu': 5.0, 'sigma': 1.5}, // Menstruation  ~3–7 days
  1: {'mu': 8.0, 'sigma': 2.5}, // Follicular    ~5–14 days
  2: {'mu': 2.0, 'sigma': 0.8}, // Ovulatory     ~1–3 days
  3: {'mu': 13.5, 'sigma': 1.5}, // Luteal        ~11–16 days
};
