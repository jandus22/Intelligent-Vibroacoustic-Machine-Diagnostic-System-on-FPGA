import torch
import torch.nn as nn

class OrderSpectrumCNN1D(nn.Module):
    def __init__(self, in_ch=1):
        super().__init__()
        self.features = nn.Sequential(
            nn.Conv1d(in_ch, 16, kernel_size=7, padding=3),
            nn.BatchNorm1d(16),
            nn.ReLU(),
            nn.MaxPool1d(2),
            nn.Conv1d(16, 32, kernel_size=7, padding=3),
            nn.BatchNorm1d(32),
            nn.ReLU(),
            nn.MaxPool1d(2),
            nn.Conv1d(32, 64, kernel_size=7, padding=3),
            nn.BatchNorm1d(64),
            nn.ReLU(),
            nn.Conv1d(64, 64, kernel_size=5, padding=2),
            nn.BatchNorm1d(64),
            nn.ReLU(),
            nn.AdaptiveAvgPool1d(1),
        )
        self.classifier = nn.Sequential(
            nn.Flatten(),
            nn.Linear(64, 32),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(32, 2),
        )

    def forward(self, x):
        return self.classifier(self.features(x))

ckpt = torch.load("lobo_case_1_test_4_val_7_best_model.pt", map_location="cpu")
model = OrderSpectrumCNN1D(1)
model.load_state_dict(ckpt["model_state_dict"])
model.eval()

x = torch.randn(1, 1, 1024)
y = model(x)
print(y.shape)
print(y)

torch.onnx.export(
    model,
    (x,),
    "bearing_cnn_1024.onnx",
    input_names=["input"],
    output_names=["logits"],
    opset_version=17,
    dynamo=True
)

print("Zapisano bearing_cnn_1024.onnx")