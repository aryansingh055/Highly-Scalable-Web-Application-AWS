#!/bin/bash
dnf update -y
dnf install -y nginx

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Scalable Web App</title>
  <style>
    body {
      margin: 0;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      font-family: Arial, sans-serif;
      background: linear-gradient(135deg, #0f172a, #1e293b);
      color: #f8fafc;
    }
    .card {
      background: #1e293b;
      border: 1px solid #334155;
      padding: 36px 44px;
      border-radius: 14px;
      text-align: center;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.35);
    }
    h1 {
      margin: 0 0 12px;
      font-size: 26px;
      color: #38bdf8;
    }
    .badge {
      display: inline-block;
      margin-top: 14px;
      padding: 8px 16px;
      background: #0f172a;
      border: 1px solid #38bdf8;
      border-radius: 8px;
      font-weight: bold;
      color: #38bdf8;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>Welcome to Scalable Web App</h1>
    <div class="badge">Availability Zone: ${AZ}</div>
  </div>
</body>
</html>
EOF

systemctl enable --now nginx