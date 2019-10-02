#!/usr/bin/env python3
import os
import sys
from subprocess import run, DEVNULL
from pdb import set_trace

# TODO: recommended packages

HOME = os.environ['HOME']
DOTFILES_PATH = os.path.join(HOME, '.dotfiles')
REQUIRED_PACKAGES = ['git', 'python3']
RECOMMENDED_PACKAGES = [
        'zsh',
        'vim',
        'htop',
        'conky',
        'i3',
        'polybar',
        'ranger',
        'rofi']
DOT_CONFIG_DIR = os.path.join(HOME, '.config')


def output_fail_message_and_exit(message, error_code):
    output_fail_message(message)
    sys.exit(error_code)


def output_fail_message(message):
    print(message, file=sys.stderr)


def check_requirements():
    print('=== Checking requirements...')
    is_ok = True
    if not HOME:
        output_fail_message_and_exit(
            'could not determine home directory, please set HOME', 1)

    if os.path.isdir(os.path.join(HOME, '.dotfiles')):
        output_fail_message_and_exit(
            f'there is a .dotfiles directory in {HOME} already, aborting',
            2)

    for package in REQUIRED_PACKAGES:
        returncode = run(
            ['which', package],
            stdout=DEVNULL,
            stderr=DEVNULL).returncode
        if returncode != 0:
            output_fail_message(f'{package} is needed for this script to work')
            is_ok = False

    for package in RECOMMENDED_PACKAGES:
        returncode = run(
            ['which', package],
            stdout=DEVNULL,
            stderr=DEVNULL).returncode
        if returncode != 0:
            output_fail_message(f'{package} is recommended.')

    if not is_ok:
        output_fail_message_and_exit(
            'Please install the missing package(s) first.'
            + '\nYou can try running the script again with the --install'
            + ' option.',
            3)


def setup_repo():
    print('=== Cloning and setting up the repo...')
    run([
        'git',
        'clone',
        '--depth=1',
        'https://github.com/cheriimoya/dotfiles.git',
        DOTFILES_PATH])


def configure():
    print('=== Starting the configuration and customisation...')
    print('Next, you will have to answer a few questions')

    questions = [
        ['git_name', 'your name (for git)', 'foo'],
        ['git_email', 'your email (for git)', 'foo@bar.com'],
        ['editor_default', 'your preferred editor', 'vim'],
        ['ethernet_id', 'the ethernet interface name', 'eth0'],
        ['wifi_id', 'the wifi interface name', 'wifi0'],
        ['font_face', 'the default font face', 'DejaVu Sans Mono'],
        ['font_size', 'the default font size', '10'],
        ['keyboard_layout', 'your keyboard layout', 'us'],
        ['zsh_theme', 'your preferred zsh theme', 'bureau']]

    for question in questions:
        answer = input(f'What is {question[1]}? (default: {question[2]}) ')
        if answer == '':
            question.append(question[2])
        else:
            question.append(answer)

    # TODO: jinja2 render

    print('=== Replacing the placeholders with your values...')
    with open('sedcmds', 'w') as sed:
        for question in questions:
            sed.write('s/{{{{ { question[0] } }}}}/{ question[3] }/\n')

    command = f'find {DOTFILES_PATH} -type f -exec sed -i -f sedcmds {{}} \\;'

    print(command)
    set_trace()
    run(command, shell=True)


def link():
    print('=== Linking files to their destination...')

    what_to_link = [
        ['aliases', '.aliases'],
        ['config/conky', '.config/conky'],
        ['config/htop/', '.config/htop'],
        ['config/i3', '.config/i3'],
        ['config/polybar', '.config/polybar'],
        ['config/ranger', '.config/ranger'],
        ['config/rofi', '.config/rofi'],
        ['gitconfig', '.gitconfig'],
        ['vim', '.vim'],
        ['vimrc', '.vimrc'],
        ['zshrc', '.zshrc'],
        ['Xresources', '.Xresources']]

    if not os.path.isdir(DOT_CONFIG_DIR):
        os.mkdir(DOT_CONFIG_DIR)

    for link_pair in what_to_link:
        link_from = os.path.join(DOTFILES_PATH, link_pair[0])
        link_to = os.path.join(HOME, link_pair[1])

        print(f'Linking {link_from} => ${link_to}...')

        try:
            if (
                    os.path.islink(link_to)
                    or os.path.isfile(link_to)
                    or os.path.isdir(link_to)):
                print(f'[X] FAILED, moving target to {os.path.join(DOTFILES_PATH, "backup", link_pair[1])}')
                os.rename(link_to, os.path.join(
                    DOTFILES_PATH,
                    'backup',
                    link_pair[1]))

            os.symlink(link_from, link_to)
        except Exception as e:
            raise e


def setup_oh_my_zsh():
    oh_my_zsh_path = os.path.join(DOTFILES_PATH, 'oh-my-zsh')
    run([
        'git',
        'clone',
        '--depth=1',
        'https://github.com/robbyrussell/oh-my-zsh.git',
        oh_my_zsh_path])


def install_programs(install_recommended=False):
    package_manager_update_command = ''
    package_manager_install_command = ''

    if not run(
            ['which', 'apt-get'], stdout=DEVNULL, stderr=DEVNULL).returncode:
        package_manager_update_command = 'sudo apt-get update'
        package_manager_install_command = 'sudo apt-get install'

    if not run(
            ['which', 'pacman'], stdout=DEVNULL, stderr=DEVNULL).returncode:
        package_manager_update_command = 'sudo pacman -Syy'
        package_manager_install_command = 'sudo pacman -S'

    if not run(
            ['which', 'nix-env'], stdout=DEVNULL, stderr=DEVNULL).returncode:
        package_manager_update_command = 'nix-channel --update'
        package_manager_install_command = 'nix-env -iA'

    if package_manager_update_command == '':
        output_fail_message_and_exit(
                'no supported package manager found, aborting',
                100)

    print('Valid package manager found!')
    print('Trying to install required packages')

    run(package_manager_update_command)
    run(
            package_manager_install_command
            + ' '
            + ' '.join(REQUIRED_PACKAGES),
            shell=True)

    if install_recommended:
        run(
                package_manager_install_command
                + ' '
                + ' '.join(RECOMMENDED_PACKAGES),
                shell=True)


def main():
    if len(sys.argv) == 2 and sys.argv[1] == '--install':
        install_programs()
    if len(sys.argv) == 2 and sys.argv[1] == '--install-recommended':
        install_programs(install_recommended=True)
    check_requirements()
    setup_repo()
    setup_oh_my_zsh()
    configure()
    link()
    print('=== Done with the installation! Enjoy!')


if __name__ == '__main__':
    main()
