import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn,
  Plugin,
} from "jsr:@shougo/dpp-vim@~1.1.0/types";
import { is } from "jsr:@core/unknownutil@~4.0.0/is";

type ExtParams = {
  // https://github.com/Shougo/dpp-ext-toml/blob/e854e37a2122f897e6dbb973ec1b2e85b9acd0ca/denops/%40dpp-exts/toml.ts#L14
  toml?: Partial<{
    path: string;
    options?: Partial<Plugin>;
  }>;
  // https://github.com/Shougo/dpp-ext-installer/blob/a42237b46437269e2b2fe0a134d4b70129640679/denops/%40dpp-exts/installer.ts#L24
  installer?: Partial<{
    checkDiff: boolean;
    githubAPIToken: string;
    logFilePath: string;
    maxProcesses: number;
    wait: number;
  }>;
};
type ProtocolParams = {
  // https://github.com/Shougo/dpp-protocol-git/blob/97188a4bb7de29a555f80bd6e5967e2bc0833ffa/denops/%40dpp-protocols/git.ts#L18
  git?: Partial<{
    cloneDepth: number;
    commandPath: string;
    defaultBranch: string;
    defaultHubSite: string;
    defaultProtocol: string;
    defaultRemote: string;
    enableCredentialHelper: boolean;
    enablePartialClone: boolean;
    pullArgs: string[];
  }>;
};

export class Config extends BaseConfig {
  override async config({
    basePath,
    contextBuilder,
    denops,
    dpp,
  }: ConfigArguments): Promise<ConfigReturn> {
    contextBuilder.setGlobal({
      protocols: ["git"],
      extParams: {
        installer: {
          checkDiff: true,
        },
      } satisfies ExtParams,
      protocolParams: {
        git: {
          enablePartialClone: true,
        },
      } satisfies ProtocolParams,
    });

    const checkFiles = [
      basePath.replace(/\/?$/, ".vim"),
      basePath.replace(/\/?$/, ".ts"),
      basePath.replace(/\/?$/, ".toml"),
    ];

    const [context, options] = await contextBuilder.get(denops);
    const { plugins: tomlPlugins } = await dpp.extAction(
      denops,
      context,
      options,
      "toml",
      "load",
      { path: checkFiles[2] },
    ) as { plugins: Plugin[] };

    const plugins = [];
    for (const p of tomlPlugins) {
      p.name = p.name.replaceAll(/^vim-|-vim$|\.n?vim$/g, "");

      // 関数呼び出しでない場合はその場で評価する
      if (is.Undefined(p.if)) {
        plugins.push(p);
        continue;
      } else if (is.Boolean(p.if) || is.Number(p.if)) {
        // deno-lint-ignore no-extra-boolean-cast
        if (Boolean(p.if)) {
          plugins.push(p);
        }

        continue;
      }

      if (!p.if.includes("(")) {
        // 即値/変数
        if (await denops.call("eval", p.if) as boolean) {
          const { if: _if, ...plugin } = p;
          plugins.push(plugin);
        }

        continue;
      }

      plugins.push(p);
    }

    return { checkFiles, plugins };
  }
}
