import {
  LoadArgs,
  Params as TomlParams,
} from "jsr:@shougo/dpp-ext-toml@~1.2.0";
import { Params as InstallerParams } from "jsr:@shougo/dpp-ext-installer@~1.1.0";
import { Params as GitParams } from "jsr:@shougo/dpp-protocol-git@~1.0.0";
import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn,
  Plugin,
} from "jsr:@shougo/dpp-vim@~2.2.0/types";
import { is } from "jsr:@core/unknownutil@~4.2.0";

type ExtParams = {
  toml?: Partial<TomlParams>;
  installer?: Partial<InstallerParams>;
};
type ProtocolParams = {
  git?: Partial<GitParams>;
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
      { path: checkFiles[2] } as LoadArgs,
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
