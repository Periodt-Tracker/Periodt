import createEmblaCarousel from 'embla-carousel-solid'

export function EmblaCarousel() {
  const [emblaRef] = createEmblaCarousel(
    () => ({ loop: true }),
  )

  return (
    <div class="overflow-hidden" ref={emblaRef}>
      <div class="flex">
        <div class="flex-[0_0_100%] min-w-0">Slide 1</div>
        <div class="flex-[0_0_100%] min-w-0">Slide 2</div>
        <div class="flex-[0_0_100%] min-w-0">Slide 3</div>
      </div>
    </div>
  )
}
