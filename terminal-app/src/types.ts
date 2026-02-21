type OutputMode = 'lexer' | 'parser' | 'interpreter';

type Result<T> =
  | {
    ok: true;
    output: T;
  }
  | {
    ok: false;
    error: string;
  };

type IndexedResult<T> = Result<T> & { index: number };

type Statement = {
  id: string
  code: string
  printOutput?: Result<string[]>
}


export type { OutputMode, Result, IndexedResult, Statement };
