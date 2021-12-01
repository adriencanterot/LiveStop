-- Closest routes
SELECT stop_name, stop_id, stop_lat, stop_lon FROM gtfs_stops GROUP BY stop_name ORDER BY ( ABS(stop_lat - 46.560487) + ABS(stop_lon - 0.386888) ) LIMIT  100