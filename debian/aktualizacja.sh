#!/bin/bash

# Ustalanie bieżącej wersji Debiana
current_version=$(cat /etc/os-release | grep VERSION_ID | cut -d '"' -f 2)

# Znajdź następną wersję; zakładamy, że wersje są numerowane sekwencyjnie
next_version=$((current_version + 1))

# Ścieżka do pliku z repozytoriami
repo_file="repository-debian-repo.txt"

# Wyszukaj repozytoria dla następnej wersji
next_repos=$(grep -A 5 "Debian ${next_version} (" "$repo_file" | grep "^deb")

# Jeśli nie znaleziono repozytoriów dla następnej wersji, zakończ skrypt
if [ -z "$next_repos" ]; then
    echo "Nie znaleziono repozytoriów dla Debiana wersji $next_version."
    exit 1
fi

# Tworzenie kopii zapasowej aktualnego pliku sources.list
cp /etc/apt/sources.list /etc/apt/sources.list.backup

# Czyszczenie pliku sources.list i dodanie nowych repozytoriów
echo "$next_repos" | sudo tee /etc/apt/sources.list

# Aktualizacja listy pakietów
sudo apt update

# Aktualizacja systemu
sudo apt full-upgrade -y

# Usunięcie niepotrzebnych pakietów
sudo apt autoremove -y

# Restart, jeśli jest to konieczne
echo "Aktualizacja do Debiana wersji $next_version zakończona. System może wymagać restartu."
