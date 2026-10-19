import { getCollection } from 'astro:content';

export const SITE_TITLE = 'shakzblogz';
export const SITE_TAGLINE = 'essays, notes & poems';

/** Prefix a site-relative path with the configured base (e.g. /shakzblogz). */
export function url(path = '/') {
	const base = import.meta.env.BASE_URL.replace(/\/$/, '');
	return `${base}/${path.replace(/^\//, '')}`;
}

export function formatDate(date: Date) {
	return date.toLocaleDateString('en-GB', { day: 'numeric', month: 'long', year: 'numeric' });
}

/** Published entries of a collection, newest first. */
export async function getEntries(collection: 'blog' | 'poetry') {
	const entries = await getCollection(collection, ({ data }) => !data.draft);
	return entries.sort((a, b) => b.data.date.valueOf() - a.data.date.valueOf());
}
