import "./main.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

Main.embed(document.getElementById("root"), {
  storyUid: "hcq",
  token:
    "SFMyNTY.eyJkYXRhIjp7ImlkIjoxfSwiZXhwIjoxNTMzMjQ1NTgxfQ.0Bk0jnYNYAC7mt-6fk9p6Ko2_4epnxjz7cxsdSEEeHQ",
  graphqlEndpoint: "http://localhost:4000/graphql"
});

registerServiceWorker();
