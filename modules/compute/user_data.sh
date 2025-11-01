#!/bin/bash

# Update system packages
sudo dnf update -y

# Install Nginx
sudo dnf install -y nginx

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Create a simple, styled landing page
cat <<'EOF' | sudo tee /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AWS Multi-Environment Infrastructure</title>
  <style>
    body {
      font-family: "Segoe UI", Roboto, sans-serif;
      background: #f9fafb;
      color: #1f2937;
      text-align: center;
      padding-top: 80px;
    }
    h1 {
      color: #2563eb;
      font-size: 2.5rem;
      margin-bottom: 10px;
    }
    p {
      color: #374151;
      font-size: 1.1rem;
    }
  </style>
</head>
<body>
  <h1>AWS Multi-Env Infrastructure</h1>
  <p>Provisioned automatically with <strong>Terraform</strong>.</p>
</body>
</html>
EOF

# Restart Nginx to apply changes
sudo systemctl restart nginx
