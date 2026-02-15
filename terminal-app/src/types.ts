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

type Statement = {
  id: string
  code: string
}


export type { OutputMode, Result, Statement };
