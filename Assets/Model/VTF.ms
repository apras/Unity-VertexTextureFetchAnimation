(
	local _startFrame = 0
	local _endFrame = 24
	local _frameLength = _endFrame - _startFrame + 1
	
	local _obj = $
	
	local _numVerts = getNumVerts _obj
	
	print _numVerts
	
	local _bmpWidth = 2
	
	while (((pow _bmpWidth 2)  + 1) < (_numVerts * _frameLength)) do
	(
		_bmpWidth  = _bmpWidth * 2
	)
	
	/*
	-- init vertex positon
	local _initVertPos = #()
	local _vertPos = #()
	
	for v = 1 to _numVerts do
	(
		local _convMat = matrix3 1
		_convMat =  _convMat * (rotateXMatrix  -90) * (scaleMatrix  [1, 1, -1])					
		
		local _vpos = meshop.getVert _obj v
		_vpos = preTranslate (inverse _obj.transform) _vpos
		_vpos = _vpos.pos
		_vpos = preTranslate _convMat _vpos
		_vpos = _vpos.pos		
		
		append _initVertPos _vpos
	)	
	
	local _maxValue = 0.0
	*/

	

	for f = _startFrame  to _endFrame do
	(
		slidertime = f
		
		for v = 1 to _numVerts do
		(
			local _convMat = matrix3 1
			_convMat =  _convMat * (rotateXMatrix  180) * (scaleMatrix  [1, 1, -1])			
			
			local _vpos = meshop.getVert _obj v
			
			_vpos = preTranslate (inverse _obj.transform) _vpos
			_vpos = _vpos.pos
			_vpos = preTranslate _convMat _vpos
			_vpos = _vpos.pos
			
			append _vertPos  _vpos
			
			
			if (_maxValue < (abs _vpos.x)) then
				_maxValue = (abs _vpos.x)
			
			if (_maxValue < (abs _vpos.y)) then
				_maxValue = (abs _vpos.y)
				
			if (_maxValue < (abs _vpos.z)) then
				_maxValue = (abs _vpos.z)
				
			
		)
	)
	
	slidertime = 0
	
	local _exportBitmap = bitmap _bmpWidth _bmpWidth hdr:true
	local _pixelIndex = 1
	
	
	for h = 1 to _bmpWidth do
	(
		local _colors = #()
		
		for w = 1 to _bmpWidth do
		(
			local _colorPos = color 255 0 0 255
			
			if ( _pixelIndex <= _vertPos.count) then
			(
				local _pos = _vertPos[_pixelIndex]
				local _x = ((_pos.x / _maxValue) * 0.5 + 0.5) * 255.0
				local _y = ((_pos.y / _maxValue) * 0.5 + 0.5) * 255.0
				local _z = ((_pos.z / _maxValue) * 0.5 + 0.5) * 255.0
				local _w = (log (_maxValue + 1.0))
				_colorPos = color _x _y _z _w
			)
			_pixelIndex = _pixelIndex + 1
			append _colors _colorPos
		)
		
		setPixels _exportBitmap [0, h - 1] _colors
	)
	
	for h = 1 to _bmpWidth do
	(
		local _colors = #()
		
		_colors = getPixels _exportBitmap [0, h - 1] _bmpWidth
	
		for _color in _colors do
		(
			if (_color.a > 0.0) then
			(
				local _packPos = [_color.r * 2.0 - 1.0, _color.g * 2.0 - 1.0, _color.b * 2.0 - 1.0]
				local _exp = (exp _color.a) - 1.0
				local _pos = [_packPos.x * _exp, _packPos.y * _exp, _packPos.z * _exp]
			)
		)
	)	
	
	display _exportBitmap
	
)