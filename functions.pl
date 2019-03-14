fly( Depart, Arrive ) :-
    flight( Depart, Arrive, time(Hour,Minute) ),
    fullPrint( 'depart', Depart, time(Hour,Minute) ),
    location( Depart, DepLat, DepLong ),
    location( Arrive, ArrLat, ArrLong ),
    haversine(Distance, DepLat, DepLong, ArrLat, ArrLong),
    flightTime( ArrTime, time(Hour,Minute), Distance ),
    fullPrint( 'arrive', Arrive, ArrTime ).

flightTime( End, time(Hour,Minute), Distance ) :-
    TravelTime is Distance/8.3333333333333333333333333333333,
    (TravelTime > 30 -> 
        TempMinutes is Minute+TravelTime,
        TotalMinutes is round(TempMinutes); 
        TotalMinutes is 30+Minute),
    %write(' '),write( TotalMinutes ),write(' '),
    addTime( End, Hour, TotalMinutes ).

addTime( Final, Hour, Minute ) :-
    (Minute > 60 ->
        NewMinute is Minute-60,
        NewHour is Hour+1,
        addTime( Final, NewHour, NewMinute );
        Final = time(Hour,Minute)).

formatTime( Time ) :-
    Time.

time( Hour, Minute ) :- 
    format("%02d:%02d", [Hour, Minute]).

portPrint( KeyA ) :- 
    airport( KeyA, Fullname, degmin(Latdeg,Latmin), degmin(Longdeg,Longmin) ),
    write( Fullname ),write('  ').

fullPrint( AD, Port, Time ) :-
    to_upper(Port,Capped),
    write( AD ), write('  '), write( Capped ), write('  '),
    portPrint( Port ),
    Time, nl.

location( Loc, Longrad, Latrad ) :-
    airport( Loc, Fullname, degmin(Latdeg,Latmin), degmin(Longdeg,Longmin) ),
    radian(Latrad, Latdeg, Latmin),
    radian(Longrad, Longdeg, Longmin).

radian( Rad, Deg, Min ) :-
    Rad is (Deg+Min/60)*3.14159265/180.

haversine( Return, Anorth, Awest, Bnorth, Bwest ) :-
   Dlon is Anorth - Bnorth,
   Dlat is Awest - Bwest,
   A is sin( Dlat / 2 ) ** 2
      + cos( Awest ) * cos( Bwest ) * sin( Dlon / 2 ) ** 2,
   Dist is 2 * atan2( sqrt( A ), sqrt( 1 - A )),
   Return is round(Dist * 3961). %write(Return).

to_upper( Lower, Upper) :-
   atom_chars( Lower, Lowerlist),
   maplist( lower_upper, Lowerlist, Upperlist),
   atom_chars( Upper, Upperlist).
