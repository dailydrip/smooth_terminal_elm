import "./main.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

Main.embed(document.getElementById("root"), {
  threadId: "ec097810-5eaa-406f-8b75-95cdd60e64ac",
  token:
    "SFMyNTY.eyJkYXRhIjp7ImlkIjoxfSwiZXhwIjoxNTMzNDU2NDc0fQ.q4eZVr05C-wTvsJhrFUNtIv-wycVOvASXLc1yZ7bY4s",
  graphqlEndpoint: "http://localhost:4000/graphql"
});

registerServiceWorker();
