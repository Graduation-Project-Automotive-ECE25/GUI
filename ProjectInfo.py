#### This program convert a given text into speech using google text to speech module
from gtts import gTTS
import vlc
import time

text = "This ADAS project uses three machine learning models: Lane Departure Warning, Traffic Sign Detection, and Drowsiness Detection.\
        It alerts the driver when drifting from lanes, identifies road signs, and detects fatigue.\
        The dashboard displays speed, RPM, lane lines, and system status, offering real-time feedback for safer driving."

sound = gTTS(text, lang='en')

sound.save('Converted_text.mp3')

p = vlc.MediaPlayer("./Converted_text.mp3")
p.set_rate(1.5)
p.play()

time.sleep(20)
