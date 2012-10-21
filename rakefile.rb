file 'bin/app.swf' => FileList['src/**/*.as']
file 'bin/app.swf' => FileList['test/src/**/*.as']
file 'bin/app.swf' => FileList['test/src/**/*.mxml']
file 'bin/app.swf' do
  args = ['mxmlc']
  args << '-sp src'
  args << '-sp test/src'
  args << '-library-path+=flexunit'
  args << '-static-rsls'
  args << '-output bin/app.swf'
  args << 'test/src/Main.mxml'

  sh args.join(' ')
end

task :clean do
  rm_rf 'bin'
end

task :default => 'bin/app.swf'
