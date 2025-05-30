# strip non-ASCII chars
# from Stack Overflow http://tinyurl.com/kj27y6l
# I'm not positive if this works
trans_table = ''.join( [chr(i) for i in range(128)] + [''] * 128 )


somebullshit = "browser. A URL likasdfg;asldfgknsdf;glsdfng;sdfognsdfgasldfgknsdf;glsdfng;sdfognsdfgasldfgknsdf;glsdfng;sdfognsdfgasldfgknsdf;glsdfng;sdfognsdfgasldfgknsdf;glsdfng;sdfognsdfgasldfgknsdf;glsdfng;sdfognsdfgasldfgknsdf;glsdfng;sdfognsdfgasldfgknsdf;glsdfng;sdfognsdfgasldfgknsdf;glsdfng;sdfognsdfge "

print("some bullshit:  " + somebullshit + "\n")

somebullshit = somebullshit.translate(trans_table)

print("some more bullshit:  " + somebullshit + "\n")
