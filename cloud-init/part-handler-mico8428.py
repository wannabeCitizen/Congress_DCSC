#part-handler
import os
import tarfile

def list_types():
	return(['application/x-tar'])

def handle_part(data, ctype, filename, payload):
	target = "/root/%s" % filename
	print("[tarball-file-handler] %s %s" % (ctype, target))
        if ctype == '__begin__' or ctype == '__end__':
		return

	with open(target, 'w') as f:
		f.write(payload)
	tarfile.open(target).extractall('/')
