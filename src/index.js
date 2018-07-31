import "./main.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

Main.embed(document.getElementById("root"), {
  storyUid: "hcq",
  token:
    "SFMyNTY.eyJkYXRhIjp7ImlkIjoxfSwiZXhwIjoxNTMzMDAzNDAzfQ.rDYpNgHOGHewBOwdHmQc3OIHncS4dUdZVm-JJ9FygLs"
});

registerServiceWorker();
