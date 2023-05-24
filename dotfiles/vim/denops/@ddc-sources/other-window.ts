import { GatherArguments } from 'https://deno.land/x/ddc_vim@v3.4.0/base/source.ts';
import { Denops, fn } from 'https://deno.land/x/ddc_vim@v3.4.0/deps.ts';
import { BaseSource, Item } from 'https://deno.land/x/ddc_vim@v3.4.0/types.ts';

type Params = {
  // include_current_filetype: boolean;
  // include_filetypes: string[];
  only_current_tabpage: boolean;
  only_viewport: boolean;
};

type WinInfo = {
  botline: number;
  bufnr: number;
  quickfix: boolean;
  terminal: boolean;
  tabnr: number;
  topline: number;
  winid: number;
  winnr: number;
};

type BufInfo = {
  bufnr: number;
  linecount: number;
};

function from1(max: number): number[] {
  return [...new Array(max).keys()].map((n) => n + 1);
}

async function get_tabpages(
  denops: Denops,
  only_current_tabpage: boolean,
): Promise<number[]> {
  if (only_current_tabpage) {
    return [await fn.tabpagenr(denops) as number];
  }

  return from1(await fn.tabpagenr(denops, '$') as number);
}

async function get_windows(denops: Denops, tn: number): Promise<number[]> {
  const last_wn = await fn.tabpagewinnr(denops, tn, '$') as number;
  const wns = from1(last_wn);
  const winids = await Promise.all(wns.map(async (wn) => {
    return await fn.win_getid(denops, wn, tn) as number;
  }));

  return winids;
}

async function get_wininfos(denops: Denops): Promise<{ [k: number]: WinInfo }> {
  return Object.fromEntries(
    (await fn.getwininfo(denops) as WinInfo[]).map((
      winfo,
    ) => [winfo.winid, winfo]),
  );
}

async function get_bufinfos(denops: Denops): Promise<{ [k: number]: BufInfo }> {
  return Object.fromEntries(
    (await fn.getbufinfo(denops, { bufloaded: true }) as BufInfo[])
      .map((binfo) => [binfo.bufnr, binfo]),
  );
}

function is_filetype(filetypes: string, filetype: string): boolean {
  const fts = filetypes.split('.');

  return fts.includes(filetype);
}

async function get_lines(
  denops: Denops,
  winfo: WinInfo,
  binfo: BufInfo,
  only_viewport: boolean,
): Promise<string[]> {
  const [top, bottom] = only_viewport
    ? [winfo.topline, winfo.botline]
    : [1, binfo.linecount];

  return await fn.getbufline(denops, binfo.bufnr, top, bottom);
}

function get_words(str: string, pattern: string): string[] {
  const re = new RegExp(pattern, 'gu');
  const words = Array.from(str.matchAll(re))
    .map((m: RegExpMatchArray) => m[0]);

  return Array.from(new Set(words));
}

export class Source extends BaseSource<Params> {
  override async gather(args: GatherArguments<Params>): Promise<Item[]> {
    const tabs = await get_tabpages(
      args.denops,
      args.sourceParams.only_current_tabpage,
    );
    const winfo = await get_wininfos(args.denops);
    const binfo = await get_bufinfos(args.denops);
    const bn = await fn.bufnr(args.denops);

    const winids: number[] = [];
    for (const tn of tabs) {
      for (const wid of await get_windows(args.denops, tn)) {
        if (winfo[wid].bufnr === bn) {
          continue;
        }
        if (winfo[wid].quickfix) {
          continue;
        }
        if (winfo[wid].terminal) {
          continue;
        }

        // const wbn = winfo[wid].bufnr;
        // const filetype = await fn.getbufvar(
        //   args.denops,
        //   wbn,
        //   '&filetype',
        // ) as string;
        // if (
        //   args.sourceParams.include_filetypes.some((ft) =>
        //     is_filetype(filetype, ft)
        //   )
        // ) {
        //   continue;
        // }

        winids.push(wid);
      }
    }

    const lines = (await Promise.all(winids.map(
      async (wid) =>
        await get_lines(
          args.denops,
          winfo[wid],
          binfo[winfo[wid].bufnr],
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
      // include_current_filetype: true,
      // include_filetypes: [],
      only_current_tabpage: false,
      only_viewport: true,
    };
  }
}
