function result = select_gdir(gmag, gdir, mag_min, angle_low, angle_high)
    result = gmag >= mag_min & angle_low <= gdir & gdir <= angle_high;