SWF = File.join('bin','app.swf')

file SWF => FileList['src/**/*.as']
file SWF => FileList['test/src/**/*.as']
file SWF => FileList['test/src/**/*.mxml']
file SWF do
  args = ['mxmlc']
  args << '-sp src'
  args << '-sp test/src'
  args << '-library-path+=flexunit'
  args << '-static-rsls'
  args << '-debug'
  args << "-output #{SWF}"
  args << '-define=CONFIG::test,true'
  args << '-define=CONFIG::release,false'
  args << 'test/src/Main.mxml'

  sh args.join(' ')
end

task :clean do
  rm_rf 'bin'
end

task :build do
  args = ['compc']
  args << '-sp src'
  args << '-include-sources src'
  args << '-define=CONFIG::test,false'
  args << '-define=CONFIG::release,true'
  args << "-output #{File.join('bin', 'stratum.swc')}"

  sh args.join(' ')
end

task :default => SWF
