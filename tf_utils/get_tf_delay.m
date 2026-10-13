function theta = get_tf_delay(G)
theta = G.IODelay + G.InputDelay + G.OutputDelay;
end