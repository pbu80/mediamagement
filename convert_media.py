import sys
from moviepy.editor import *
from pydub import AudioSegment

def convert_video(input_file, output_file):
    # Load video file
    video = VideoFileClip(input_file)

    # Calculate aspect ratio
    aspect_ratio = video.size[0] / video.size[1]

    # Set the new resolution
    new_width = 1280
    new_height = 720
    if aspect_ratio > (16 / 9):
        new_width = int(new_height * aspect_ratio)
    else:
        new_height = int(new_width / aspect_ratio)

    # Resize video to 720p
    resized_video = video.resize(newsize=(new_width, new_height))

    # Convert audio to AAC 2.0
    audio = AudioSegment.from_file(input_file)
    aac_audio = audio.set_channels(2).export(format="aac")

    # Set the converted audio to the video
    final_video = resized_video.set_audio(AudioFileClip(aac_audio.name))

    # Write the output file
    final_video.write_videofile(output_file, codec="libx264", audio_codec="aac")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python convert_video.py <input_file> <output_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    convert_video(input_file, output_file)
