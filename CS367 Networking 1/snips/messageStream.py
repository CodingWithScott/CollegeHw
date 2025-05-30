class MessageStream:
	"""A MessageStream class"""
	
	def __init__(self, buff_size):
		self.buff_size = buff_size
		self.buffer_string = ""
		self.curr_index = 0
		self.paran_count = 0
		
		self.my_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		
	def readData():
		# read data from socket into the buffer
		print("I just read data from the socket into me")
		
	def getMessage():
		# do something with the 
		print("I just did something with the data I have in me")
		
	def resync():
		# get rid of everything up to the curr_index
		print("I just resynced with the stream")
