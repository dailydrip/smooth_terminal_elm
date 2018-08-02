import "./main.css";
import { Main } from "./Main.elm";

export default (el, { storyUid, token }) => {
  return Main.embed(el, {
    storyUid,
    token
  });
}
