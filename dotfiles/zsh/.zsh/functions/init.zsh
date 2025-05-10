source ~/.zsh/functions/_helpers.zsh
source ~/.zsh/functions/_speed-test.zsh

convert_video_to_gif() {
    local fps=60
    local input_video="$1"
    local output_filename="output_$(date +"%Y%m%d%H%M%S").gif"

    ffmpeg -i "$input_video" -vf "fps=$fps,scale=1920:-1:flags=lanczos" -c:v gif "$output_filename"

    echo "GIF created: $output_filename"
}

set_timezone() {
    local timezone=""
    local timezones_path="/usr/share/zoneinfo"

    echo "Select a timezone:"
    select tz_option in $timezones_path/*; do
        if [[ -e $tz_option ]]; then
            timezone="${tz_option##*/}"
            break
        else
            echo "Invalid option. Please select a valid timezone."
        fi
    done

    sudo ln -sf "$tz_option" "/etc/localtime"
    echo "Timezone set to $timezone"
}

extract() {
    params_required "File" "Usage: extract [path/compressed_filename]" "$1"

    case $1 in
    *.tar.bz2) tar xvjf $1 ;;
    *.tar.gz) tar xvzf $1 ;;
    *.tar.xz) tar xvJf $1 ;;
    *.lzma) unlzma $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar x -ad $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xvf $1 ;;
    *.tbz2) tar xvjf $1 ;;
    *.tgz) tar xvzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *.xz) unxz $1 ;;
    *.exe) cabextract $1 ;;
    *.deb) ar x $1 ;;
    *) echo "extract: '$1' - unknown archive method" ;;
    esac

    if [ $? -eq 0 ]; then
        echo "File extracted successfully: $1"
    else
        echo "Failed to extract file: $1"
    fi
}

compress() {
    params_required "File" "Usage: compress [compressed_filename].<tar|tar.gz|zip> <file_or_directory>" "$1"

    compressed_filename="$1"
    file_or_dir="$2"

    case $compressed_filename in
    *.tar) tar cvf "$compressed_filename" "$file_or_dir" ;;
    *.tar.gz) tar czvf "$compressed_filename" "$file_or_dir" ;;
    *.tar.bz2) tar cjvf "$compressed_filename" "$file_or_dir" ;;
    *.tar.xz) tar cJvf "$compressed_filename" "$file_or_dir" ;;
    *.zip) zip -r "$compressed_filename" "$file_or_dir" ;;
    *) echo "compress: '$compressed_filename' - unknown compression method" ;;
    esac

    if [ $? -eq 0 ]; then
        echo "Compression successful: $compressed_filename"
    else
        echo "Compression failed: $compressed_filename"
    fi
}

weather () {
    curl wttr.in
}

live-wallpaper-picker() {
  local wallpapers_dir="$HOME/Wallpapers/Live"
  local video_file

  # Check if mpvpaper is installed
  if ! command -v mpvpaper >/dev/null; then
    echo "Error: mpvpaper is not installed. Install it first."
    echo "GitHub: https://github.com/GhostNaN/mpvpaper"
    return 1
  fi

  # Check if directory exists
  if [[ ! -d "$wallpapers_dir" ]]; then
    echo "Error: Directory not found: $wallpapers_dir"
    return 1
  fi

  # Use fzf to select a video file
  video_file=$(find "$wallpapers_dir" -type f \( -name "*.mp4" -o -name "*.webm" \) | fzf )

  # Exit if no file was selected
  if [[ -z "$video_file" ]]; then
    echo "No video selected. Exiting."
    return 0
  fi

  # Kill existing mpvpaper instances
  pkill mpvpaper
  
  # Launch mpvpaper with the selected video
  mpvpaper -o "--loop --no-audio" "*" "$video_file" & disown

  echo "Wallpaper set to: $video_file"
}

clear_history() {
    echo -n "Do you want to clear the history? [y/N] "
    read -r response  # Read user input

    if [[ "$response" =~ ^[Yy]$ ]]; then
        atuin search --delete-it-all
        history -c
    else
    fi
}

