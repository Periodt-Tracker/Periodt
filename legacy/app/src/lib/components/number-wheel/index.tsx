import createEmblaCarousel from "embla-carousel-solid";
import type { EmblaCarouselType } from "embla-carousel";
import { createEffect, createSignal, Index, mergeProps } from "solid-js";

const CIRCLE_DEGREES = 360;
const WHEEL_ITEM_SIZE = 30;
const WHEEL_ITEM_COUNT = 20;

const WHEEL_ITEM_RADIUS = CIRCLE_DEGREES / WHEEL_ITEM_COUNT;
const IN_VIEW_DEGREES = 180;
const WHEEL_RADIUS = Math.round(WHEEL_ITEM_SIZE / 2 / Math.tan(Math.PI / WHEEL_ITEM_COUNT));

const isInView = (wheelLocation: number, slidePosition: number): boolean =>
  Math.abs(wheelLocation - slidePosition) < IN_VIEW_DEGREES;

type SlideStylesType = {
  opacity: number;
  transform: string;
};

const getSlideStyles = (
  emblaApi: EmblaCarouselType,
  index: number,
  loop: boolean,
  slideCount: number,
  totalRadius: number,
): SlideStylesType => {
  const wheelLocation = emblaApi.scrollProgress() * totalRadius;
  const positionDefault = emblaApi.scrollSnapList()[index] * totalRadius;
  const positionLoopStart = positionDefault + totalRadius;
  const positionLoopEnd = positionDefault - totalRadius;

  let inView = false;
  let angle = index * -WHEEL_ITEM_RADIUS;

  if (isInView(wheelLocation, positionDefault)) {
    inView = true;
  }

  if (loop && isInView(wheelLocation, positionLoopEnd)) {
    inView = true;
    angle = -CIRCLE_DEGREES + (slideCount - index) * WHEEL_ITEM_RADIUS;
  }

  if (loop && isInView(wheelLocation, positionLoopStart)) {
    inView = true;
    angle = -(totalRadius % CIRCLE_DEGREES) - index * WHEEL_ITEM_RADIUS;
  }

  if (inView) {
    return {
      opacity: 1,
      transform: `rotateX(${angle}deg) translateZ(${WHEEL_RADIUS}px)`,
    };
  }
  return { opacity: 0, transform: "none" };
};

export const getContainerStyles = (wheelRotation: number): Pick<SlideStylesType, "transform"> => ({
  transform: `translateZ(${WHEEL_RADIUS}px) rotateX(${wheelRotation}deg)`,
});

export const getItemValuesStyles = <T = string>(
  emblaApi: EmblaCarouselType | undefined,
  loop: boolean,
  items: WheelEntry<T>[],
  totalRadius: number,
): Array<{
  label: string;
  value: T;
  opacity: number;
  transform: string;
}> => {
  const result = items.map((item, index) => {
    return emblaApi
      ? {
        ...item,
        ...getSlideStyles(emblaApi, index, loop, items.length, totalRadius),
      }
      : { ...item, opacity: 0, transform: "none" };
  });

  return result;
};

export type NumberWheelProps<T> = {
  intialValue?: T;
  items: WheelEntry<T>[];
  loop?: boolean;
  onValueChange?: (value: T) => void;
  minWidth?: string;
  perspective?: "left" | "right";
};

export type WheelEntry<T> = { label: string; value: T };

export const PickerItem = <T = string>(__props: NumberWheelProps<T>) => {
  const props = mergeProps({ loop: false, perspective: "left" }, __props);

  const [emblaRef, emblaApi] = createEmblaCarousel(() => ({
    loop: props.loop,
    axis: "y",
    dragFree: true,
  }));

  const slideCount = () => props.items.length;

  const [wheelReady, setWheelReady] = createSignal(false);
  const [wheelRotation, setWheelRotation] = createSignal(0);

  const totalRadius = () => slideCount() * WHEEL_ITEM_RADIUS;
  const rotationOffset = () => (props.loop ? 0 : WHEEL_ITEM_RADIUS);
  const containerStyles = () => getContainerStyles(wheelRotation());

  const itemValues = () => getItemValuesStyles(emblaApi(), props.loop, props.items, totalRadius());

  const inactivateEmblaTransform = () => {
    const api = emblaApi();

    if (!api) {
      return;
    }

    const { translate, slideLooper } = api.internalEngine();
    translate.clear();
    translate.toggleActive(false);

    slideLooper.loopPoints.forEach(({ translate }) => {
      translate.clear();
      translate.toggleActive(false);
    });
  };

  const rotateWheel = () => {
    const api = emblaApi();

    if (!api) {
      return 0;
    }

    const rotation = slideCount() * WHEEL_ITEM_RADIUS - rotationOffset();

    setWheelRotation(rotation * api.scrollProgress());
  };

  createEffect(() => {
    const api = emblaApi();

    if (!api) {
      return;
    }

    api.scrollTo(
      props.items.findIndex((v) => v.value === props.intialValue),
      false,
    );

    api.on("select", () => {
      if (!props.onValueChange) {
        return;
      }

      const items = itemValues();
      const snap = api.selectedScrollSnap();

      if (snap < items.length) {
        props.onValueChange(items[snap].value);
      }
    });

    api.on("pointerUp", () => {
      const { scrollTo, target, location } = api.internalEngine();
      const diffToTarget = target.get() - location.get();
      const factor = Math.abs(diffToTarget) < WHEEL_ITEM_SIZE / 3 ? 20 : 0.1;
      const distance = diffToTarget * factor;
      scrollTo.distance(distance, true);
    });

    api.on("scroll", rotateWheel);

    api.on("resize", () => {
      setWheelReady(false);

      setWheelReady(() => {
        api.reInit();
        inactivateEmblaTransform();
        rotateWheel();

        return true;
      });
    });

    setWheelReady(true);
    inactivateEmblaTransform();
    rotateWheel();
  });

  const handleClick = (index: number) => {
    const api = emblaApi();

    if (api) {
      api.scrollTo(index);
    }
  };

  return (
    <div class="embla__ios-picker" style={{ "min-width": props.minWidth }}>
      {/* scene */}
      <div class="embla__ios-picker__scene">
        {/* viewport */}
        <div
          class="embla__ios-picker__viewport"
          ref={emblaRef}
          style={{ perspective: "1000px" }} // explicit, no Tailwind magic
        >
          {/* container */}
          <div
            class="embla__ios-picker__container"
            style={wheelReady() ? containerStyles() : { transform: "none" }}
          >
            <Index each={itemValues()}>
              {(item, index) => (
                <div
                  class="embla__ios-picker__slide"
                  onClick={() => handleClick(index)}
                  style={
                    wheelReady()
                      ? {
                        opacity: item()
                          .opacity,
                        transform: item()
                          .transform,
                        "text-align":
                          "right",
                      }
                      : {
                        position: "static",
                        transform: "none",
                        "text-align":
                          "left",
                      }
                  }
                >
                  {item().label}
                </div>
              )}
            </Index>
          </div>
        </div>
      </div>
    </div>
  );
};
