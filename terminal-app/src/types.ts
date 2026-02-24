type OutputMode = 'lexer' | 'parser' | 'type checker' | 'interpreter';

type ReplResponseResult<T> =
  | {
    ok: true;
    pending: true
  }
  | {
    ok: true;
    pending: false
    output: T;
  }
  | {
    ok: false;
    error: string;
  };

type InterpreterResponseResult<T> =
  | {
    ok: true;
    output: T;
  }
  | {
    ok: false;
    error: string;
  };

type IndexedResult<T> = InterpreterResponseResult<T> & { index: number };

type Statement = {
  id: string
  code: string
  printOutput?: ReplResponseResult<string[]>
  submittedWhilePending?: boolean
}


export type { OutputMode, InterpreterResponseResult, ReplResponseResult, IndexedResult, Statement };
