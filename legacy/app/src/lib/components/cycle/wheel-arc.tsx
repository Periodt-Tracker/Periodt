import type { Component } from "solid-js";
import { center, circumference, radius, width } from "./constants";
import type { CycleArcType } from "./types";

export interface CycleArcProps {
	arc: CycleArcType;
}

const CycleArc: Component<CycleArcProps> = (props) => {
	return (
		<circle
			cx={center}
			cy={center}
			r={radius}
			fill="none"
			stroke={props.arc.colour}
			stroke-width={width}
			stroke-linecap="round"
			stroke-dasharray={`0 ${circumference}`}
			stroke-dashoffset={-props.arc.offset}
			transform="rotate(-90 60 60)"
		>
			<animate
				attributeName="stroke-dasharray"
				begin={`${props.arc.delay}ms`}
				from={`0 ${circumference}`}
				to={`${props.arc.length} ${circumference}`}
				dur={`${props.arc.duration}ms`}
				fill="freeze"
			/>
		</circle>
	);
};

export default CycleArc;
