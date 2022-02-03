if ! grep -Ewq 'size:' "/home/zim/.config/alacritty/alacritty.yml"; then
    echo "size not found"
else
    echo "size present"
fi 
