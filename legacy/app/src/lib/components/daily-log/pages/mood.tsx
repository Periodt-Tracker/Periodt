import type { StepperPageComponent } from "@/lib/components/stepper/types";
import type { DayEntry } from "@/lib/symptoms/types";

const DailyMoodPage: StepperPageComponent<DayEntry> = (props) => {
	const isValid = props.form.mood?.length > 0;
};

export default DailyMoodPage;
