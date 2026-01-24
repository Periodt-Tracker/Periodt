export function setCssVariable(name: string, value: string) {
	document.documentElement.style.setProperty(`--${name}`, value);
}
