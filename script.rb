require 'pathname'
keyPath=Pathname.new('/project_system/master.key')
unless keyPath.exist?
	system 'EDITOR=nano rails credentials:edit  && mv -n /projeto/config/master.key /project_system/master.key && ln -sf /project_system/master.key /projeto/config/master.key'
	keyPath=Pathname.new('/project_system/master.key')
	print('Chave existe:')
	print(keyPath.exist?)
end
