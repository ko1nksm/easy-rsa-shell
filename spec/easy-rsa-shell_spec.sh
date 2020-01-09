Describe "easy-rsa-shell.sh"
  Include "./easy-rsa-shell"

  Describe "normalizepath()"
    wslpath() { [ "$1" = "-ma" ] && echo "windows path of ${2##*/}"; }

    Context "Run in WSL1"
      uname() {
        case $1 in
          -a) echo "Linux desktop 4.4.0-18362-Microsoft"
        esac
      }

      It "translates to Windows path"
        When call normalizepath "foo"
        The output should eq "windows path of foo"
      End
    End

    Context "Run in WSL2"
      uname() {
        case $1 in
          -a) echo "Linux computer 4.19.84-microsoft-standard"
        esac
      }

      It "translates to Windows path"
        When call normalizepath "foo"
        The output should eq "windows path of foo"
      End
    End

    Context "Run in Ubuntu"
      uname() {
        case $1 in
          -a) echo "Linux server 5.3.0-23-generic"
        esac
      }

      It "translates relative path to absolute path"
        When call normalizepath "foo"
        The output should eq "$PWD/foo"
      End

      It "does not absolute translates"
        When call normalizepath "/foo"
        The output should eq "/foo"
      End
    End
  End
End
