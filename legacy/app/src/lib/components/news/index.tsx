import type { News } from "@/lib/cycle/types";
import { FaSolidLink } from "solid-icons/fa";
import { Show, type Component } from "solid-js";

export interface NewsProps {
	news: News;
}

const NewsView: Component<NewsProps> = (props) => {
	return (
		<div class="flex flex-col gap-2">
			<h3 class="font-semibold text-xl text-center">{props.news.title}</h3>

			<Show when={props.news.image}>
				{(image) => <img alt="news cover" src={image()} />}
			</Show>

			<span class="text-center opacity-60">{props.news.description}</span>

			<Show when={props.news.link}>
				{(link) => (
					<a
						class="inline-flex gap-2 place-items-center mx-auto underline underline-offset-2 opacity-80"
						href={link()}
					>
						<FaSolidLink />
						Find out more
					</a>
				)}
			</Show>
		</div>
	);
};

export default NewsView;
