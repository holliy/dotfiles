import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn,
  Plugin,
  // DppOptions,
} from "https://deno.land/x/dpp_vim@v0.2.0/types.ts";
import {
  isBoolean,
  isUndefined,
} from "https://deno.land/x/unknownutil@v3.18.1/is.ts";
import {} from "https://deno.land/x/unknownutil@v3.18.1/mod.ts";


type ExtParams = {
  // https://github.com/Shougo/dpp-ext-toml/blob/341cc272231b3d6a62607a22718fb6dc45e30c54/denops/%40dpp-exts/toml.ts#L11
  toml?: Partial<{
    path: string;
    options?: Partial<Plugin>;
  }>;
  installer?: Partial<{
    checkDiff: boolean;
    githubAPIToken: string;
    logFilePath: string;
    maxProcesses: number;
  }>;
};
type ProtocolParams = {
  // https://github.com/Shougo/dpp-protocol-git/blob/53f8531e1e3040127287b09f8bfbb93d77ef7994/denops/%40dpp-protocols/git.ts#L18
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
        }
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
      p.name = p.name.replaceAll(/^vim-|-vim$|\.n?vim$/g, '');

      // 関数呼び出しでない場合はその場で評価する
      if (isUndefined(p.if)) {
        plugins.push(p);
        continue;
      } else if (isBoolean(p.if)) {
        if (p.if) {
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
