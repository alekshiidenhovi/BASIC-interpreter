import type { OutputMode } from "./types";

export { };

declare global {
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

  type NetworkType = "bluetooth" | "cellular" | "ethernet" | "none" | "wifi" | "wimax" | "other" | "unknown";
  type ConnectionType = "slow-2g" | "2g" | "3g" | "4g";

  interface NetworkInformation extends EventTarget {
    downLink: number;
    downlinkMax: number;
    effectiveType: ConnectionType;
    rtt: number;
    saveData: boolean;
    type: NetworkType;
    onchange: ((this: NetworkInformation, ev: Event) => any) | null;
  }

  interface Navigator {
    getBattery?: () => Promise<BatteryManager>;
    connection?: NetworkInformation;
  }

  function interpretBASIC(code: string, mode: OutputMode): string[];
}
