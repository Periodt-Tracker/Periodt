import { NativeBiometric } from "@capgo/capacitor-native-biometric";
import { FaSolidFingerprint } from "solid-icons/fa";
import { type Component, onMount } from "solid-js";
import Button from "../button";

export interface DeviceGuardProps {
  onVerified: VoidFunction;
}

const DeviceGuard: Component<DeviceGuardProps> = (props) => {
  const verify = async () => {
    const result = await NativeBiometric.isAvailable();

    if (!result.isAvailable) {
      return props.onVerified();
    }

    await NativeBiometric.verifyIdentity({ useFallback: true })
      .then(() => props.onVerified())
      .catch(() => false);
  };

  onMount(verify);

  return (
    <div class="w-svw h-svh bg-cycle-light grid place-items-center">
      <Button class="p-4" onClick={verify}>
        <FaSolidFingerprint size={36} />
      </Button>
    </div>
  );
};

export default DeviceGuard;
