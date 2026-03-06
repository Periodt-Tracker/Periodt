/* @refresh reload */
import { render } from "solid-js/web";
import "./index.css";
import { JeepSqlite } from "jeep-sqlite/dist/components/jeep-sqlite";

import App from "./app.tsx";

customElements.define("jeep-sqlite", JeepSqlite);

const root = document.getElementById("root");

render(() => <App />, root!);
