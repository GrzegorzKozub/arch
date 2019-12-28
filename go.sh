set -e -o verbose

# go

sudo pacman -S --noconfirm go

for PACKAGE in \
  `# https://github.com/Microsoft/vscode-go` \
  github.com/acroca/go-symbols \
  github.com/cweill/gotests/... \
  github.com/davidrjenni/reftools/cmd/fillstruct \
  github.com/fatih/gomodifytags \
  github.com/go-delve/delve/cmd/dlv \
  github.com/godoctor/godoctor \
  github.com/haya14busa/goplay/cmd/goplay \
  github.com/josharian/impl \
  github.com/mdempsky/gocode \
  github.com/ramya-rao-a/go-outline \
  github.com/rogpeppe/godef \
  github.com/stamblerre/gocode \
  github.com/uudashr/gopkgs/cmd/gopkgs \
  golang.org/x/lint/golint \
  golang.org/x/tools/cmd/goimports \
  golang.org/x/tools/cmd/gorename \
  golang.org/x/tools/cmd/guru \
  golang.org/x/tools/gopls \
  `# https://github.com/fatih/vim-go` \
  `#github.com/davidrjenni/reftools/cmd/fillstruct` \
  `#github.com/fatih/gomodifytags` \
  github.com/fatih/motion \
  `#github.com/go-delve/delve/cmd/dlv` \
  github.com/golangci/golangci-lint/cmd/golangci-lint \
  `#github.com/josharian/impl` \
  github.com/jstemmer/gotags \
  github.com/kisielk/errcheck \
  github.com/klauspost/asmfmt/cmd/asmfmt \
  github.com/koron/iferr \
  `#github.com/mdempsky/gocode` \
  `#github.com/rogpeppe/godef` \
  `#github.com/stamblerre/gocode` \
  github.com/zmb3/gogetdoc \
  `#golang.org/x/lint/golint` \
  `#golang.org/x/tools/cmd/goimports` \
  `#golang.org/x/tools/cmd/gorename` \
  `#golang.org/x/tools/cmd/guru` \
  `#golang.org/x/tools/gopls` \
  honnef.co/go/tools/cmd/keyify
do
  echo $PACKAGE
  go get -u $PACKAGE
done

