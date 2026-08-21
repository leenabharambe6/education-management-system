const express = require("express");
const cookieParser = require("cookie-parser");
const dotenv = require("dotenv");
dotenv.config();

const { v1Routes } = require("./src/routes/v1");
const { handleGlobalError } = require("./src/middlewares");

v1Routes.stack.forEach((layer, i) => {
  const orig = layer.handle;
  const label = `layer[${i}] path=${layer.regexp} name=${orig.name || "anon"} arity=${orig.length}`;
  layer.handle = function (a, b, c, d) {
    if (orig.length === 4) {
      console.log("ERR->", label);
      return orig.call(this, a, b, c, d);
    }
    console.log("HIT ->", label);
    return orig.call(this, a, b, c);
  };
});

const app = express();
app.use(express.json());
app.use(cookieParser());
app.use("/api/v1", v1Routes);
app.use(handleGlobalError);

app.listen(5011, () => console.log("probe listening on 5011"));
