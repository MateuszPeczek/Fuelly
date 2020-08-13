class LocalizedLabels {
    String distance;
    String distanceMetricUnit;
    String distanceImperialUnit;
    String fuel;
    String fuelMetricUnit;
    String fuelImperialUnit;
    String next;
    String previous;
    String overall;
    String save;
    String back;
    String cancel;
    String select;
    String yes;
    String options;
    String history;
    String settings;
    String apperance;
    String units;
    String darkMode;
    String accentColor;
    String chooseAccentColor;
    String metricUnits;
    String imperialUnits;
    String deleteConfirmation;
    String later;
    String noThanks;
    String rateApp;

    LocalizedLabels({
      this.accentColor,
      this.apperance,
      this.back,
      this.cancel,
      this.chooseAccentColor,
      this.darkMode,
      this.deleteConfirmation,
      this.distance,
      this.distanceImperialUnit,
      this.distanceMetricUnit,
      this.fuel,
      this.fuelImperialUnit,
      this.fuelMetricUnit,
      this.history,
      this.imperialUnits,
      this.metricUnits,
      this.next,
      this.options,
      this.overall,
      this.previous,
      this.save,
      this.select,
      this.settings,
      this.units,
      this.yes,
      this.later,
      this.rateApp,
      this.noThanks
    });

    factory LocalizedLabels.fromJson(Map<String, dynamic> parsedJson) {
      return LocalizedLabels(
        accentColor: parsedJson['accentColor'],
        apperance: parsedJson['apperance'],
        back: parsedJson['back'],
        cancel: parsedJson['cancel'],
        chooseAccentColor: parsedJson['chooseAccentColor'],
        darkMode: parsedJson['darkMode'],
        deleteConfirmation: parsedJson['deleteConfirmation'],
        distance: parsedJson['distance'],
        distanceImperialUnit: parsedJson['distanceImperialUnit'],
        distanceMetricUnit: parsedJson['distanceMetricUnit'],
        fuel: parsedJson['fuel'],
        fuelImperialUnit: parsedJson['fuelImperialUnit'],
        fuelMetricUnit: parsedJson['fuelMetricUnit'],
        history: parsedJson['history'],
        imperialUnits: parsedJson['imperialUnits'],
        metricUnits: parsedJson['metricUnits'],
        next: parsedJson['next'],
        options: parsedJson['options'],
        overall: parsedJson['overall'],
        previous: parsedJson['previous'],
        save: parsedJson['save'],
        select: parsedJson['select'],
        settings: parsedJson['settings'],
        units: parsedJson['units'],
        yes: parsedJson['yes'],
        later: parsedJson['later'],
        rateApp: parsedJson['rateApp'],
        noThanks: parsedJson['noThanks']
      );
    }
}