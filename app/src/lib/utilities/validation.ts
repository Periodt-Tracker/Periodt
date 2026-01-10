export function minLength(value: number, message: string) {
	return (text: string) => (text.length < value ? message : null);
}

export function maxLength(value: number, message: string) {
	return (text: string) => (text.length > value ? message : null);
}
