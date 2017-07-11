module.exports = (file, options, file_, content)->
	return content if not file.endsWith('.js')
	
	result = 
	require('falafel') content, (node)-> if node.type is 'Identifier'
		switch node.name
			when 'EXPAND_ARGUMENTS'
				targetName = 'args'
				slicePos = 0
				
				if node.parent.type is 'CallExpression'
					targetName = node.parent.arguments[0].name
					if node.parent.arguments[1]
						slicePos = node.parent.arguments[1].value or 0

				node.parent.update("
					var $_len = arguments.length,
						$_i = #{slicePos-1},
						#{targetName} = new Array($_len);

					while (++$_i < $_len)
						#{targetName}[$_i] = arguments[$_i]
				")

	return result.toString()







