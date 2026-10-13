function G = remove_tf_delay(G)
G.IODelay = 0;
G.InputDelay = 0;
G.OutputDelay = 0;
end