import { Router, Request, Response } from "express";

const routes: Router = Router();

routes.get("/", (request: Request, response: Response) => {
  response
    .status(200)
    .json({
      data: {
        id: "123",
        nome: "Gabriela",
        projeto: "Cafelier",
        time: "03",
        organizacao: "Pipoca Ágil",
      },
    });
});

export { routes };
