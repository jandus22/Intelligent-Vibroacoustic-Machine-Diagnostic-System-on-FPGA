import numpy as np
import onnxruntime as ort

sess = ort.InferenceSession(
    "bearing_cnn_1024.onnx",
    providers=["CPUExecutionProvider"]
)

x = np.random.randn(1, 1, 1024).astype(np.float32)
logits = sess.run(None, {"input": x})[0]

exp = np.exp(logits - np.max(logits, axis=1, keepdims=True))
probs = exp / np.sum(exp, axis=1, keepdims=True)

print("logits:", logits)
print("probs :", probs)
print("pred  :", int(np.argmax(probs, axis=1)[0]))