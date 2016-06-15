import argparse, yaml, os, os.path

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input")
parser.add_argument("-o", "--output")
parser.add_argument("--tm2", "--tm", action="store_const", const="tm2", dest="action")
parser.add_argument("--tm2source", "--tmsource", action="store_const", const="tm2source", dest="action")

parser.add_argument("--source", action="store_true", dest="source")
parser.add_argument("--no-source", action="store_false", dest="source")

args = parser.parse_args()

cwd = os.getcwd()

with open(args.input) as fp:
    projectfile = yaml.load(fp)

if args.action == 'tm2':
    new_layers = []
    for layer in projectfile['Layer']:
        new_layers.append({'id': layer['id']})
    projectfile['Layer'] = new_layers

    if args.source:
        projectfile['source'] = "tmsource://{}/osm-carto.tm2source/".format(cwd)

elif args.action == 'tm2source':
    projectfile['maxzoom'] = 14
    del projectfile['source']
    del projectfile['styles']
else:
    raise NotImplementedError()

with open(args.output, 'w') as fp:
    yaml.safe_dump(projectfile, fp)

