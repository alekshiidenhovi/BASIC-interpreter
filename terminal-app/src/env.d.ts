interface BatteryManager extends EventTarget {
  readonly charging: boolean;
  readonly chargingTime: number;
  readonly dischargingTime: number;
  readonly level: number;
  onchargingchange: ((this: BatteryManager, ev: Event) => any) | null;
  onchargingtimechange: ((this: BatteryManager, ev: Event) => any) | null;
  ondischargingtimechange: ((this: BatteryManager, ev: Event) => any) | null;
  onlevelchange: ((this: BatteryManager, ev: Event) => any) | null;
}

interface NetworkInformation extends EventTarget {
  downLink: number;
  downlinkMax: number;
  effectiveType: "slow-2g" | "2g" | "3g" | "4g";
  rtt: number;
  saveData: boolean;
  type: "bluetooth" | "cellular" | "ethernet" | "none" | "wifi" | "wimax" | "other" | "unknown";
  onchange: ((this: NetworkInformation, ev: Event) => any) | null;
}

interface Navigator {
  getBattery?: () => Promise<BatteryManager>;
  connection?: NetworkInformation;
}

interface Window {
  interpretBASIC?: (code: string, mode: import("./types").OutputMode) => string[];
}
