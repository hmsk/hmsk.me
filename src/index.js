import Elm from "./Me.elm";
const app = Elm.Me.embed(document.getElementById("me"));

import fontawesome from "@fortawesome/fontawesome";
import icons from '@fortawesome/fontawesome-free-regular';
fontawesome.library.add(icons);
