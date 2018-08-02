import "./main.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

Main.embed(document.getElementById("root"), {
  storyUid: "hcq",
  token:
    "SFMyNTY.eyJkYXRhIjp7ImlkIjoxfSwiZXhwIjoxNTMzMDE5NDc1fQ.nainu8W-VymorplRrEdCPiTeTOwYuMI2ck4K1mf7IuM",
  graphqlEndpoint: "http://localhost:4000/graphql"
});

registerServiceWorker();
