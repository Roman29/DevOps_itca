backup_dir=~/linux_p2/backup
old_backup_dir=~/linux_p2/old_backup
source_dir=~/linux_p2

mkdir -p "$backup_dir" "$old_backup_dir"

for file in "$source_dir"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        current_date=$(date +"%Y-%m-%d")
        archive_name="${filename}_${current_date}.tar.gz"

        echo "Archiving $filename"
        tar -czf "$backup_dir/$archive_name" -C "$source_dir" "$filename"

        # Check if the archive is older than 3 minutes
        archive_timestamp=$(stat -c %Y "$backup_dir/$archive_name")
        current_timestamp=$(date +%s)
        time_difference=$((current_timestamp - archive_timestamp))

        if [ "$time_difference" -gt 180 ]; then
            echo "Moving $archive_name to old_backup directory"
            mv "$backup_dir/$archive_name" "$old_backup_dir/$archive_name"
        fi
    fi
done