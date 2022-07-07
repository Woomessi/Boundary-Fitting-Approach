function ang = getAngle(v1, v2)
ang = acos(dot(v1,v2)/(norm(v1)*norm(v2)));
end