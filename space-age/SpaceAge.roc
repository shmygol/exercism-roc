module [age]

Planet : [
    Mercury,
    Venus,
    Earth,
    Mars,
    Jupiter,
    Saturn,
    Uranus,
    Neptune,
]

age : Planet, Dec -> Dec
age = |planet, seconds|
    seconds / orbitalPeriod(planet)

orbitalPeriod : Planet -> Dec
orbitalPeriod = |planet|
    when planet is
        Mercury -> 7600520
        Venus -> 19411026
        Earth -> 31557600
        Mars -> 59355072
        Jupiter -> 374099200
        Saturn -> 929292800
        Uranus -> 2651376000
        Neptune -> 5200418592
