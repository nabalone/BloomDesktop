#!/bin/bash
# server=build.palaso.org
# project=Bloom
# build=Bloom-Default-Linux64-Continuous
# root_dir=..
# Auto-generated by https://github.com/sillsdev/BuildUpdate.
# Do not edit this file by hand!

cd "$(dirname "$0")"

# *** Functions ***
force=0
clean=0

while getopts fc opt; do
case $opt in
f) force=1 ;;
c) clean=1 ;;
esac
done

shift $((OPTIND - 1))

copy_auto() {
if [ "$clean" == "1" ]
then
echo cleaning $2
rm -f ""$2""
else
where_curl=$(type -P curl)
where_wget=$(type -P wget)
if [ "$where_curl" != "" ]
then
copy_curl "$1" "$2"
elif [ "$where_wget" != "" ]
then
copy_wget "$1" "$2"
else
echo "Missing curl or wget"
exit 1
fi
fi
}

copy_curl() {
echo "curl: $2 <= $1"
if [ -e "$2" ] && [ "$force" != "1" ]
then
curl -# -L -z "$2" -o "$2" "$1"
else
curl -# -L -o "$2" "$1"
fi
}

copy_wget() {
echo "wget: $2 <= $1"
f1=$(basename $1)
f2=$(basename $2)
cd $(dirname $2)
wget -q -L -N "$1"
# wget has no true equivalent of curl's -o option.
# Different versions of wget handle (or not) % escaping differently.
# A URL query is the only reason why $f1 and $f2 should differ.
if [ "$f1" != "$f2" ]; then mv $f2\?* $f2; fi
cd -
}


# *** Results ***
# build: Bloom-Default-Linux64-Continuous (bt403)
# project: Bloom
# URL: https://build.palaso.org/viewType.html?buildTypeId=bt403
# VCS: https://github.com/BloomBooks/BloomDesktop.git [master]
# dependencies:
# [0] build: bloom-win32-static-dependencies (bt396)
#     project: Bloom
#     URL: https://build.palaso.org/viewType.html?buildTypeId=bt396
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"connections.dll"=>"DistFiles", "MSBuild.Community.Tasks.dll"=>"build/", "MSBuild.Community.Tasks.Targets"=>"build/"}
# [1] build: Bloom Help 5.3 (Bloom_Help_BloomHelp53)
#     project: Help
#     URL: https://build.palaso.org/viewType.html?buildTypeId=Bloom_Help_BloomHelp53
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"*.chm"=>"DistFiles"}
# [2] build: pdf.js (bt401)
#     project: BuildTasks
#     URL: https://build.palaso.org/viewType.html?buildTypeId=bt401
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"pdfjs-viewer.zip!**"=>"DistFiles/pdf"}
#     VCS: https://github.com/mozilla/pdf.js.git [gh-pages]
# [3] build: GeckofxHtmlToPdf-xenial64-continuous (GeckofxHtmlToPdf_GeckofxHtmlToPdfXenial64continuous)
#     project: GeckofxHtmlToPdf
#     URL: https://build.palaso.org/viewType.html?buildTypeId=GeckofxHtmlToPdf_GeckofxHtmlToPdfXenial64continuous
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"Args.dll"=>"lib/dotnet", "GeckofxHtmlToPdf.exe"=>"lib/dotnet", "GeckofxHtmlToPdf.exe.config"=>"lib/dotnet"}
#     VCS: https://github.com/BloomBooks/geckofxHtmlToPdf [refs/heads/master]
# [4] build: PdfDroplet-Linux-master-Continuous (bt344)
#     project: PdfDroplet
#     URL: https://build.palaso.org/viewType.html?buildTypeId=bt344
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"PdfDroplet.exe"=>"lib/dotnet", "PdfSharp.dll*"=>"lib/dotnet"}
#     VCS: https://github.com/sillsdev/pdfDroplet [master]
# [5] build: TidyManaged-master-linux64-continuous (bt351)
#     project: TidyManaged
#     URL: https://build.palaso.org/viewType.html?buildTypeId=bt351
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"TidyManaged.dll*"=>"lib/dotnet"}
#     VCS: https://github.com/BloomBooks/TidyManaged.git [master]
# [6] build: Linux master continuous (XliffForHtml_LinuxMasterContinuous)
#     project: XliffForHtml
#     URL: https://build.palaso.org/viewType.html?buildTypeId=XliffForHtml_LinuxMasterContinuous
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"HtmlXliff.*"=>"lib/dotnet", "HtmlAgilityPack.*"=>"lib/dotnet"}
#     VCS: https://github.com/sillsdev/XliffForHtml [refs/heads/master]

# make sure output directories exist
mkdir -p ../DistFiles
mkdir -p ../DistFiles/pdf
mkdir -p ../Downloads
mkdir -p ../build/
mkdir -p ../lib/dotnet

# download artifact dependencies
copy_auto https://build.palaso.org/guestAuth/repository/download/bt396/latest.lastSuccessful/connections.dll ../DistFiles/connections.dll
copy_auto https://build.palaso.org/guestAuth/repository/download/bt396/latest.lastSuccessful/MSBuild.Community.Tasks.dll ../build/MSBuild.Community.Tasks.dll
copy_auto https://build.palaso.org/guestAuth/repository/download/bt396/latest.lastSuccessful/MSBuild.Community.Tasks.Targets ../build/MSBuild.Community.Tasks.Targets
copy_auto https://build.palaso.org/guestAuth/repository/download/Bloom_Help_BloomHelp53/latest.lastSuccessful/Bloom.chm ../DistFiles/Bloom.chm
copy_auto https://build.palaso.org/guestAuth/repository/download/bt401/latest.lastSuccessful/pdfjs-viewer.zip ../Downloads/pdfjs-viewer.zip
copy_auto https://build.palaso.org/guestAuth/repository/download/GeckofxHtmlToPdf_GeckofxHtmlToPdfXenial64continuous/latest.lastSuccessful/Args.dll ../lib/dotnet/Args.dll
copy_auto https://build.palaso.org/guestAuth/repository/download/GeckofxHtmlToPdf_GeckofxHtmlToPdfXenial64continuous/latest.lastSuccessful/GeckofxHtmlToPdf.exe ../lib/dotnet/GeckofxHtmlToPdf.exe
copy_auto https://build.palaso.org/guestAuth/repository/download/GeckofxHtmlToPdf_GeckofxHtmlToPdfXenial64continuous/latest.lastSuccessful/GeckofxHtmlToPdf.exe.config ../lib/dotnet/GeckofxHtmlToPdf.exe.config
copy_auto https://build.palaso.org/guestAuth/repository/download/bt344/latest.lastSuccessful/PdfDroplet.exe ../lib/dotnet/PdfDroplet.exe
copy_auto https://build.palaso.org/guestAuth/repository/download/bt344/latest.lastSuccessful/PdfSharp.dll ../lib/dotnet/PdfSharp.dll
copy_auto https://build.palaso.org/guestAuth/repository/download/bt351/latest.lastSuccessful/TidyManaged.dll ../lib/dotnet/TidyManaged.dll
copy_auto https://build.palaso.org/guestAuth/repository/download/bt351/latest.lastSuccessful/TidyManaged.dll.config ../lib/dotnet/TidyManaged.dll.config
copy_auto https://build.palaso.org/guestAuth/repository/download/XliffForHtml_LinuxMasterContinuous/latest.lastSuccessful/HtmlXliff.exe ../lib/dotnet/HtmlXliff.exe
copy_auto https://build.palaso.org/guestAuth/repository/download/XliffForHtml_LinuxMasterContinuous/latest.lastSuccessful/HtmlXliff.exe.mdb ../lib/dotnet/HtmlXliff.exe.mdb
copy_auto https://build.palaso.org/guestAuth/repository/download/XliffForHtml_LinuxMasterContinuous/latest.lastSuccessful/HtmlAgilityPack.dll ../lib/dotnet/HtmlAgilityPack.dll
# extract downloaded zip files
unzip -uqo ../Downloads/pdfjs-viewer.zip -d "../DistFiles/pdf"
# End of script
