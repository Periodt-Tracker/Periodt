enum Mood { happy, excited, neutral, irritable, angry, anxious, sad, stressed }

// note the different discriminator's here for null-ish
// values.
//
// none    - the user checked and there was none
// unknown - the user submitted a log for the day
//           but did not check
// null    - the user did not submit a log for
//           today
enum DischargeColour {
  bloody,
  clear,
  green,
  grey,
  white,
  yellow,
  none,
  unknown,
}

enum BleedingLevel { none, unkown, light, medium, heavy, extraHeavy }

enum DischargeConsistency {
  purulent,
  thick,
  slippery,
  pusy,
  thin,
  curdy,
  frothy,
  unknown,
}

enum DischargeOdor { foul, fishy, mushroom, none, unknown }

enum Countries { uk, us }

enum Provider { nhs, clevelandClinic }

typedef ConditionData = ({Map<Countries, List<ProviderLink>> links});

typedef ProviderLink = ({Provider provider, String url});

enum Condition {
  bacterialVaginosis((
    links: {
      Countries.uk: [
        (
          provider: Provider.nhs,
          url: "https://www.nhs.uk/conditions/bacterial-vaginosis/",
        ),
      ],
      Countries.us: [
        (
          provider: Provider.clevelandClinic,
          url:
              "https://my.clevelandclinic.org/health/diseases/3963-bacterial-vaginosis",
        ),
      ],
    },
  )),

  candiasis((
    links: {
      Countries.uk: [
        (
          provider: Provider.nhs,
          url: "https://www.nhs.uk/conditions/thrush-in-men-and-women/",
        ),
      ],
    },
  ));

  final ConditionData data;

  const Condition(this.data);
}
