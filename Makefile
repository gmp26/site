LIVE=/www/cmep/html

clean: site
	./site clean

deploy: check
	rsync --recursive --delete --checksum _site/ ${LIVE}

check: rebuild
	./site check

post:
	touch posts/`date +%Y-%m-%d`-${TITLE}.mkd

preview: rebuild
	./site preview

rebuild: site
	./site rebuild -v

site: site.hs
	ghc --make site.hs
