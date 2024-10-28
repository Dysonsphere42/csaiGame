#!/usr/bin/env sh

declare -a questionsLinuxArray=()
declare -a questionsWindowsArray=()

declare -a score

playsound(){
    if [ $1 == "True" ]; then
        mpv audio/correct-choice-43861.mp3 > /dev/null
    else
        mpv audio/training-program-incorrect1-88736.mp3 > /dev/null
    fi
}

parseTextFiles(){
    local line

    local questionsLinux=questionsLinux.txt
    local questionsWindows=questionsWindows.txt

    local optionsLinux=optionsLinux.txt
    local optionsWindows=optionsWindows.txt

    while IFS= read -r line; do
        questionsLinuxArray+=("$line")
    done < "$questionsLinux"

    while IFS= read -r line; do
        questionsWindowsArray+=("$line")
    done < "$questionsWindows"
}

runGameLinux(){
    score=0
    for i in "${!questionsLinuxArray[@]}"; do
        local ip1=$((i + 1))
        local ansLine=$(sed -n "${ip1}p" optionsLinux.txt)

        echo "${questionsLinuxArray[i]}"

        IFS=','
        correct=$(echo "$ansLine" | sed 's/,.*//')

        read -ra options <<< "$ansLine"
        for ((i = ${#options[@]} - 1; i > 0; i--)); do
            j=$((RANDOM % (i + 1)))

            temp=${options[i]}
            options[i]=${options[j]}
            options[j]=$temp
        done

        local counter=1
        for index in "${!options[@]}"; do
            echo "$counter) ${options[index]}"
            ((counter++))
        done
        echo "0) skip"
        read -p "Answer: " ans

        if [[ $ans -ge 1 && $ans -le ${#options[@]} ]]; then
            selected="${options[ans - 1]}"
            if [ "$selected" = "$correct" ]; then
                ((score++))
                echo "correct"
                playsound "True"
            else
                echo "incorrect"
                playsound "False"
            fi
        elif [ $ans = 0 ]; then
             echo "Skipped!"
             sleep 1
        else
            echo "Index is out of bounds."
            sleep 1
        fi

        clear
    done
    echo "Score: $score / 10"
    read -p "Press Enter to continue..."
}

runGameWindows(){
    score=0
    for i in "${!questionsWindowsArray[@]}"; do
        local ip1=$((i + 1))
        local ansLine=$(sed -n "${ip1}p" optionsWindows.txt)

        echo "${questionsWindowsArray[i]}"

        IFS=','
        correct=$(echo "$ansLine" | sed 's/,.*//')

        read -ra options <<< "$ansLine"
        for ((i = ${#options[@]} - 1; i > 0; i--)); do
            j=$((RANDOM % (i + 1)))

            temp=${options[i]}
            options[i]=${options[j]}
            options[j]=$temp
        done

        local counter=1
        for index in "${!options[@]}"; do
            echo "$counter) ${options[index]}"
            ((counter++))
        done
        echo "0) skip"
        read -p "Answer: " ans

        if [[ $ans -ge 1 && $ans -le ${#options[@]} ]]; then
            selected="${options[ans - 1]}"
            if [ "$selected" = "$correct" ]; then
                ((score++))
                echo "correct"
                playsound "True"
            else
                echo "incorrect"
                playsound "False"
            fi
        elif [ $ans = 0 ]; then
            echo "Skipped!"
            sleep 1
        else
            echo "Index out of bounds."
            sleep 1
        fi

        clear
    done
    echo "Score: $score / 10"
    read -p "Press Enter to continue..."
}

aboutMenu() {
    local choice

    while true; do
        clear
        echo "================================"
        echo "             About...           "
        echo "================================"
        echo ""
        echo "This a game made by Dylan Woods for the Cybersecurity and AI course"
        echo ""
        echo "1. Back"
        echo "2. Play Windows (Medium)"
        echo "3. Play Linux (Hard)"
        echo "0. Exit"
        echo "================================"
        echo -n "Enter your choice [0-4]: "
        read choice

        case $choice in
            1)
                return
                ;;
            2)
                runGameWindows
                ;;
            3)
                runGameLinux
                ;;
            0)
                echo "Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid option"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

mainMenu() {
    local choice

    while true; do
        clear
        echo "================================"
        echo "           Main Menu            "
        echo "================================"
        echo "1. Play Windows (Medium)"
        echo "2. Play Linux (Hard)"
        echo "3. About"
        echo "0. Exit"
        echo "================================"
        echo -n "Enter your choice [0-3]: "
        read choice

        case $choice in
            1)
                clear
                runGameWindows
                ;;
            2)
                clear
                runGameLinux
                ;;
            3)
                aboutMenu
                ;;
            0)
                echo "Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid option"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

main(){
    score=0
    parseTextFiles
    mainMenu
}

main
