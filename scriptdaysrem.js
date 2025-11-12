// https://runkit.com/teu_usuario/dias-restantes
const express = require("express");
const app = express();

app.get("/", (req, res) => {
  const hoje = new Date();
  const fimProjeto = new Date("2025-12-21");
  const diffTime = fimProjeto - hoje;
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  res.json({
    schemaVersion: 1,
    label: "dias restantes",
    message: diffDays.toString(),
    color: "yellow"
  });
});

app.listen(3000, () => console.log("Servidor a correr"));
