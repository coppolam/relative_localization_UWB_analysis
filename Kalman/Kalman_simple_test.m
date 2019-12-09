clearvars;

km = KalmanClass("Kalman_no_heading3");
inp = [10;11;12;13;14;15];
measurements = [1;2;3;4;5;6;7];
dt = 0.1;
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.updateKalman(inp,measurements,dt);
km.x_k_k