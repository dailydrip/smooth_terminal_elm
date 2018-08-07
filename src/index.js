import "./main.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

Main.embed(document.getElementById("root"), {
  threadId: "14537901-a83e-4398-9814-103de81942cb",
  token:
    "SFMyNTY.eyJkYXRhIjp7ImlkIjoxfSwiZXhwIjoxNTMzNjI3MDUwfQ.yqb8yxC4KpK5bPKic7gze3AVUrXkh_KRTb-trRGPlb8",
  graphqlEndpoint: "http://localhost:4000/graphql"
});

registerServiceWorker();
