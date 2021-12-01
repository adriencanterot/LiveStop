-- All routes for one stop
SELECT gtfs_stops.stop_id, gtfs_stops.stop_name, gtfs_routes.route_id, gtfs_routes.route_short_name, gtfs_trips.direction_id, gtfs_routes.route_long_name FROM gtfs_stops
INNER JOIN gtfs_stop_times ON gtfs_stop_times.stop_id = gtfs_stops.stop_id
INNER JOIN gtfs_trips ON gtfs_trips.trip_id = gtfs_stop_times.trip_id
INNER JOIN gtfs_routes ON gtfs_trips.route_id = gtfs_routes.route_id
WHERE gtfs_stops.stop_name = "La Roche"
GROUP BY gtfs_routes.route_id, gtfs_trips.direction_id
