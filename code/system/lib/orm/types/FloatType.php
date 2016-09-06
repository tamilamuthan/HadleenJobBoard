<?php

class SJB_FloatType extends SJB_IntegerType
{
	public function __construct($property_info)
	{
		parent::__construct($property_info);
		$this->sql_type 		= 'DECIMAL';
		$this->default_template = 'float.tpl';
	}
	
	function isValid()
	{	
		$value = $this->property_info['value'];
		
		$i18n = SJB_ObjectMother::createI18N();
		if (!$i18n->isValidFloat($value)) {
			return 'NOT_FLOAT_VALUE';
		}

		if (!empty($this->property_info['validators'])) {
			foreach ($this->property_info['validators'] as $validator) {
				$isValid = $validator::isValid($this);
				if ($isValid !== true)
					return $isValid;
			}
		}
		return true;
	}
	
	function getSQLValue()
	{
		$value = $this->_format_value_with_signs_num();
		return $value ? $value : null;
	}

    function getKeywordValue()
    {
		return $this->_format_value_with_signs_num();
	}
	
	function _format_value_with_signs_num()
	{
		$i18n = SJB_ObjectMother::createI18N();
		$value = $i18n->getInput('float', $this->property_info['value']);
			
		if (isset($this->property_info['signs_num']) && is_numeric($this->property_info['signs_num'])) {			
			return sprintf("%0." . $this->property_info['signs_num'] . "f", $value);
		}
		
		return $value;
	}

	public static function getFieldExtraDetails()
	{
		return array(
			array(
				'id'		=> 'signs_num',
				'caption'	=> 'Signs number after comma', 
				'type'		=> 'integer',
				'minimum'	=> 0,
				),
		);
	}
	
	function getSQLFieldType()
	{
		return "FLOAT NULL";
	}
}
