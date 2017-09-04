import parallel
import datetime

class BAParallelMarker:

    def __init__(self):
      self.p = parallel.Parallel()

    def prepare(self, i):
      self.mark(i)

    def mark(self, i):
      i = i % 255 + 1
      print 'marker: ', i
      self.p.setData(i)
        
    
