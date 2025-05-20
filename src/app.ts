import express from "express";
// import cors from "cors";
// import morgan from "morgan";
import { routes } from "./router/routes"; // index.ts dentro da pasta routes

const app = express();

// Middlewares
// app.use(cors());
// app.use(morgan("dev"));

app.use(express.json());

// Rotas
app.use("/api", routes);

export default app;
