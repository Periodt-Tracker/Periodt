import type { RawDictionary } from "../types";

export const dict: RawDictionary = {
  title: "Periodt.",
  setup: {
    welcome: "Witamy w periodt!",
    start: "Rozpocznij",
  },
  home: {
    welcome: (name: string) => `Cześć ${name}`,
  },
  settings: {
    locale: {
      select: "Wybierz swoj jezyk",
      confirm: "Wybierz bitch",
      en: "Angielski",
      pl: "Polski",
    },
    title: "Ustawienia",
    profile: {
      title: "Mój profil",
      description: "Imię, język",
    },
    security: {
      title: "Bezpieczeństwo i prywatność",
      description: "Blokada aplikacji, ekran prywatności",
      device: {
        title: "Urządzenie",
        description: "Wymagaj odcisku palca, Face ID, hasła telefonu itp...",
      },
      pin: {
        title: "PIN",
        description: "Ustaw własny PIN różny od blokady urządzenia",
      },
      none: {
        title: "Brak",
        description: "Brak blokady dla periodt.",
      },
      blank_screen: {
        title: "Pusty ekran",
        description: "Ukryj zawartość periodt. w przełączniku aplikacji",
      },
      lock_on_resume: {
        title: "Blokuj po powrocie",
        description:
          "Zablokuj periodt. po każdym powrocie, nawet jeśli aplikacja nie została zamknięta",
      },
    },
  },
  fallback: {
    title: "To nie powinno się zdarzyć",
    description:
      "Znaleziono brakującą stronę — wyślij nam wiadomość, opisując jak tu trafiłeś(-aś)",
    return: "Wróć",
  },
};
