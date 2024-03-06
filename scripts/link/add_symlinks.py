import os, argparse, pyuac, configparser

parser = argparse.ArgumentParser(description="Create symlinks")
parser.add_argument("config", default="config.ini", nargs="?", help="config file")
args = parser.parse_args()
config_file = args.config

os.chdir(os.path.dirname(__file__))
config = configparser.ConfigParser(allow_no_value=True)

# create config file if none
if not os.path.isfile(config_file):
    with open(config_file, "w", encoding="utf-8") as f:
        config.add_section("link")
        config["link"]["root"] = "../../"
        config["link"]["src"] = "\n<path>"
        config["link"]["dest"] = "\n<path>"
        config.write(f)
        print(f"Created {config_file}")

# admin user required to create symlinks
if not pyuac.isUserAdmin():
    pyuac.runAsAdmin()
    exit()

# read config
config.read(config_file)
for section in config.sections():
    root = config[section]["root"]
    src = config[section]["src"].strip().splitlines()
    dest = config[section]["dest"].strip().splitlines()

    # go to root path
    os.chdir(os.path.dirname(__file__))
    os.chdir(root)

    # add symlinks
    for s in src:
        s = s.strip()
        isdir = os.path.isdir(s)
        isfile = os.path.isfile(s)
        if not isdir and not isfile:
            continue
        for d in dest:
            d = d.strip()
            if not os.path.isdir(d):
                continue
            link = f"{d}/{s}"
            if os.path.isdir(link) or os.path.isfile(link):
                continue
            if os.path.islink(link):
                os.unlink(link)
            os.symlink(os.path.realpath(s), link, isdir)
