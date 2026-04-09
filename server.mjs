import express from "express";
import winston from "winston";
import asyncHandler from "express-async-handler";
import { v4 as uuidv4 } from "uuid";

const logger = winston.createLogger({
  level: "info",
  format: winston.format.json(),
  transports: [new winston.transports.Console()],
});

const fileLogger = winston.createLogger({
  level: "info",
  format: winston.format.json(),
  transports: [new winston.transports.File({ filename: "full.log" })],
});

const env = (envKey, required = true) => {
  const envValue = process.env[envKey];
  if (!envValue && required) {
    logger.error("Mangler miljøvariabel: " + envKey);
    process.exit(1);
  }
  return envValue;
};

const config = {
  pamUrl: env("PAM_URL"),
};

const server = express();

async function startApp() {
  try {
    server.use(["/internal/is_alive", "/internal/is_ready"], (req, res) => {
      res.send("Ok");
    });

    server.get(
      "/",
      asyncHandler(async (req, res) => {
        const stillingstittel =
          typeof req.query.q === "string" ? req.query.q : "";
        const params = new URLSearchParams({ stillingstittel });
        const response = await fetch(
          `${config.pamUrl}/rest/typeahead/stilling?${params.toString()}`,
          {
            headers: {
              "Nav-CallId": uuidv4(),
            },
          }
        );

        if (!response.ok) {
          throw new Error(`PAM request failed with status ${response.status}`);
        }

        res.json(await response.json());
      })
    );

    const port = 4000;
    server.listen(port, () => logger.info(`Listening on port ${port}`));
  } catch (error) {
    logger.error("Error during start-up");
    fileLogger.error("Error during start-up", error);
  }
}

startApp().catch((err) => logger.error(err));
