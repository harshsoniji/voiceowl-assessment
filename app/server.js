const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({ 
    status: "ok",
    message: "Hey! Voiceowl Assessment Accomplished :). v2.0"
  });
});

app.listen(port, () => {
  console.log(`Voiceowl DevSecOps app running on port ${port}`);
});
