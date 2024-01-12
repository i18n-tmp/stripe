import uridir from "@3-/uridir";
import viteConf from "@3-/vite-conf";
const conf = await viteConf(ROOT);
conf.server.https = false;
export default conf;
