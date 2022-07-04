from moviepy.editor import *


VideoFileClip('./convertFiles/convert.mp4').speedx(1).write_gif('./convertFiles/out.gif')
print('done')