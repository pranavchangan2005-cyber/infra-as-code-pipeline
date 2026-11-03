const express = require("express");

const app = express();
const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({
    message: "Zero-Touch Deployment Successful - Version 2",
    status: "running",
    environment: process.env.ENVIRONMENT || "dev"
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy"
  });
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Application listening on port ${port}`);
});
