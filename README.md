# Schejewel

<img src="https://i.imgur.com/CJo1L3Y.png">

Schejewel is an app that uses the Google Calendar API to find gaps in the schedules of several users and calculate ideal meeting times.
My current goal with this project is to create a small rails webapp that takes in a start and end date and updates the page to display ideal times.
You may notice the view portion is kind of a mess, and this is because I'm using this project as an oppurtunity to experiment with React, and the Materialize CSS framework. 
I also initially created a script version of the app which is complete and can be used by anyone by simply adding your google calender share code into the script.

<h3>Script Version Setup</h3>
To configure the script add your google calender share url on this line.

```ruby

  calendar_id = 'YOUR CALENDER URL HERE'
  response = service.list_events(calendar_id,
                                single_events: true,
                                order_by: 'startTime',
                                time_min: timeMin,
                                time_max: timeMax)
```

To change the start and end date in the script, edit the method call at the bottum of thye script

```ruby
calculate(Time.parse("2018-11-05 00:00:00 EST").iso8601,Time.parse("2018-11-10 00:00:00 EST").iso8601)
```
