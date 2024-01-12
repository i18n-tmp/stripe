import uridir from "@3-/uridir";
import viteConf from "@3-/vite-conf";
import { readFileSync } from "fs";
import mkcert from "vite-plugin-mkcert";
//https://web.dev/articles/how-to-use-local-https?hl=zh-cn
const ROOT = uridir(import.meta);
const conf = await viteConf(ROOT);
conf.hmr = { clientPort: 443 };
conf.server.https = true;
conf.plugins.push(mkcert());
export default conf;
