import { GatherArguments } from 'https://deno.land/x/ddc_vim@v3.4.1/base/source.ts';
import { Denops, fn, op } from 'https://deno.land/x/ddc_vim@v3.4.1/deps.ts';
import { BaseSource, Item } from 'https://deno.land/x/ddc_vim@v3.4.1/types.ts';

type Params = {
  include_same_filetype: boolean;
  include_filetypes: string[];
  only_current_tabpage: boolean;
  only_viewport: boolean;
};

function filetype_list(filetypes: string): string[] {
  return filetypes.split('.');
}

function is_filetype_include(
  filetype1: string[],
  filetype2: string[],
): boolean {
  return filetype1.some((ft) => filetype2.includes(ft));
}

async function get_lines(
  denops: Denops,
  wid: number,
  only_viewport: boolean,
): Promise<string[]> {
  const [top, bottom] = only_viewport
    ? [await fn.line(denops, 'w0', wid), await fn.line(denops, 'w$', wid)]
    : [1, await fn.line(denops, '$', wid)];

  const wbn = await fn.winbufnr(denops, wid);
  return await fn.getbufline(denops, wbn, top, bottom);
}

function get_words(str: string, pattern: string): string[] {
  const re = new RegExp(pattern, 'gu');
  const words = Array.from(str.matchAll(re))
    .map((m: RegExpMatchArray) => m[0]);

  return Array.from(new Set(words));
}

export class Source extends BaseSource<Params> {
  override async gather(args: GatherArguments<Params>): Promise<Item[]> {
    const winids = await args.denops.eval(
      'map(getwininfo(), { _, v -> v.winid })',
    ) as number[];

    const tn = await fn.tabpagenr(args.denops);
    const bn = await fn.bufnr(args.denops);
    const bft = filetype_list(
      await fn.getbufvar(args.denops, bn, '&filetype') as string,
    );

    const source_winids: number[] = [];
    for (const wid of winids) {
      const wtn = (await fn.win_id2tabwin(args.denops, wid))[0] as number;
      if (args.sourceParams.only_current_tabpage && wtn !== tn) {
        continue;
      }

      const wbn = await fn.winbufnr(args.denops, wid);
      if (wbn === bn) {
        continue;
      }

      const wbtype = await op.buftype.getBuffer(args.denops, wbn);
      if (wbtype === 'quickfix') {
        continue;
      }
      if (wbtype === 'terminal') {
        continue;
      }

      const wft = filetype_list(
        await op.filetype.getBuffer(args.denops, wbn),
      );
      if (
        args.sourceParams.include_same_filetype &&
        is_filetype_include(wft, bft)
      ) {
        // nop
      } else if (
        args.sourceParams.include_filetypes.includes('*') ||
        is_filetype_include(wft, args.sourceParams.include_filetypes)
      ) {
        // nop
      } else {
        continue;
      }

      source_winids.push(wid);
    }

    const lines = (await Promise.all(source_winids.map(
      async (wid) =>
        await get_lines(
          args.denops,
          wid,
          args.sourceParams.only_viewport,
        ),
    ))).flat().flat();

    const str = lines.length > 0 ? lines.join(' ') : '';

    const words: Item[] = get_words(str, args.options.keywordPattern)
      .map((word) => ({ word }));

    return words;
  }

  override params(): Params {
    return {
      include_same_filetype: true,
      include_filetypes: ['*'],
      only_current_tabpage: false,
      only_viewport: true,
    };
  }
}
