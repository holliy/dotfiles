import { GatherArguments } from "jsr:@shougo/ddc-vim@~6.0.0/source";
import { BaseSource, Item } from "jsr:@shougo/ddc-vim@~6.0.0/types";
import { convertKeywordPattern } from "jsr:@shougo/ddc-vim@~6.0.0/utils";
import { Denops } from "jsr:@denops/std@~7.0.0";
import * as fn from "jsr:@denops/std@~7.0.0/function";
import * as op from "jsr:@denops/std@~7.0.0/option";
import { ensure, is } from "jsr:@core/unknownutil@~4.0.0";

type Params = {
  includeSameFiletype: boolean;
  includeFiletypes: string[];
  onlyCurrentTabpage: boolean;
  onlyViewport: boolean;
  contextLines: number;
};

function filetypeList(filetypes: string): string[] {
  return filetypes.split(".");
}

function isFiletypeInclude(
  filetype1: string[],
  filetype2: string[],
): boolean {
  const ft1 = new Set(filetype1);
  const ft2 = new Set(filetype2);
  return !ft1.isDisjointFrom(ft2);
}

async function calcRange(
  denops: Denops,
  wid: number,
  onlyViewport: boolean,
  contextLines: number,
): Promise<[number, number]> {
  const cursorLine = await fn.line(denops, ".", wid);
  const [top, bottom] = onlyViewport
    ? [await fn.line(denops, "w0", wid), await fn.line(denops, "w$", wid)]
    : [Math.max(cursorLine - contextLines, 0), cursorLine + contextLines];

  return [top, bottom];
}

async function getLines(
  denops: Denops,
  wid: number,
  top: number,
  bottom: number,
): Promise<string[]> {
  const wbn = await fn.winbufnr(denops, wid);
  return await fn.getbufline(denops, wbn, top, bottom);
}

function getWords(str: string, pattern: string): string[] {
  const re = new RegExp(pattern, "gu");
  const words = Array.from(str.matchAll(re))
    .map((m: RegExpMatchArray) => m[0]);

  return Array.from(new Set(words));
}

export class Source extends BaseSource<Params> {
  override async gather(args: GatherArguments<Params>): Promise<Item[]> {
    const winids = ensure(
      await args.denops.eval("map(getwininfo(), { _, v -> v.winid })"),
      is.ArrayOf(is.Number),
    );

    const tn = await fn.tabpagenr(args.denops);
    const bn = await fn.bufnr(args.denops);
    const bft = filetypeList(
      await op.filetype.getBuffer(args.denops, bn),
    );

    const sourceWinids: number[] = [];
    for (const wid of winids) {
      const wtn = ensure(
        (await fn.win_id2tabwin(args.denops, wid))[0],
        is.Number,
      );
      if (args.sourceParams.onlyCurrentTabpage && wtn !== tn) {
        continue;
      }

      const wbn = await fn.winbufnr(args.denops, wid);
      if (wbn === bn) {
        continue;
      }

      const wbtype = await op.buftype.getBuffer(args.denops, wbn);
      if (wbtype === "quickfix") {
        continue;
      }
      if (wbtype === "terminal") {
        continue;
      }

      const wft = filetypeList(
        await op.filetype.getBuffer(args.denops, wbn),
      );
      if (
        args.sourceParams.includeSameFiletype &&
        isFiletypeInclude(wft, bft)
      ) {
        // nop
      } else if (
        args.sourceParams.includeFiletypes.includes("*") ||
        isFiletypeInclude(wft, args.sourceParams.includeFiletypes)
      ) {
        // nop
      } else {
        continue;
      }

      sourceWinids.push(wid);
    }

    const words = (await Promise.all(sourceWinids.map(
      async (wid) => {
        const [top, bottom] = await calcRange(
          args.denops,
          wid,
          args.sourceParams.onlyViewport,
          args.sourceParams.contextLines,
        );
        const lines = await getLines(args.denops, wid, top, bottom);
        const wbn = await fn.winbufnr(args.denops, wid);
        const keywordPattern = await convertKeywordPattern(
          args.denops,
          args.sourceOptions.keywordPattern,
          wbn,
        );

        return getWords(lines.join(" "), keywordPattern)
          .map((word) => ({ word }));
      },
    ))).flat();

    return words;
  }

  override params(): Params {
    return {
      includeSameFiletype: true,
      includeFiletypes: ["*"],
      onlyCurrentTabpage: false,
      onlyViewport: true,
      contextLines: 50,
    };
  }
}
