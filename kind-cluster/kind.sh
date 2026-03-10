# Install Kind (based on architecture)
# ----------------------------
if ! command -v kind &>/dev/null; then
  echo "📦 Installing Kind..."

  curl -Lo kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64

  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/
  echo "✅ Kind installed successfully."
else
  echo "✅ Kind is already installed."
fi

