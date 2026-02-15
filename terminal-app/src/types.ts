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



export type { OutputMode, Result };
