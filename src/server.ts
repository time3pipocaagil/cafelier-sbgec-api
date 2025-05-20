import dotenv from "dotenv";
import app from "./app";

dotenv.config();

const PORT: String | number = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`🚀Servidor rodando em http://localhost:${PORT}`);
});
