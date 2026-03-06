import {
  FaBrandsGithub,
  FaBrandsInstagram,
  FaBrandsReddit,
  FaBrandsTiktok,
} from "solid-icons/fa";

export const social_media = [
  {
    id: "github",
    name: "periodt-tracker",
    url: "https://github.com/periodt-tracker/Periodt",
    icon: FaBrandsGithub,
  },
  {
    id: "tiktok",
    name: "@periodt.tracker",
    url: "https://www.tiktok.com/@periodt.tracker",
    icon: FaBrandsTiktok,
  },
  {
    id: "instagram",
    name: "periodt.tracker",
    url: "https://www.instagram.com/periodt.tracker",
    icon: FaBrandsInstagram,
  },
  {
    id: "reddit",
    name: "u/periodt-tracker",
    url: "https://www.reddit.com/user/periodt-tracker/",
    icon: FaBrandsReddit,
  },
] as const;
