class Dashing.WorldClock extends Dashing.Widget
  # configuration
  locations: [
    { zone: "Pacific/Auckland", display_location: "NZL", primary: true },
    { zone: "Australia/Sydney", display_location: "SYD" },
    { zone: "Etc/UTC", display_location: "GMT" },
    { zone: "Asia/Kuala_Lumpur", display_location: "KL" },
   # { zone: "Europe/London", display_location: "EDH" }
  ]

  startClock: ->
    for location in @locations
      date = moment().tz(location.zone)
      location.time = [date.hours(), date.minutes(), date.seconds()].map (n)->
        ('0' + n).slice(-2)
      .join(':')
      minutes = 60 * date.hours() + date.minutes()
      totalWidth = document.querySelector('.hours').clientWidth - 1
      offset = (minutes / (24.0 * 60)) * totalWidth

      clock = document.querySelector("." + location.display_location)
      if(clock)
        ['-webkit-transform', '-moz-transform', '-o-transform', '-ms-transform', 'transform'].forEach (vendor) ->
          clock.style[vendor] = "translateX(" + offset + "px)"

          if(location.primary)
            @set('time', location.time)
        , @

    setTimeout @startClock.bind(@), 1000

  setupHours: ->
    hours = []
    for h in [0..23]
      do (h) ->
        hours[h] = {}
        hours[h].dark = h< 7 || h>= 19
        hours[h].name = if h == 12 then h else h%12
    @set('hours', hours)

  ready: ->
    @setupHours()
    @startClock()
