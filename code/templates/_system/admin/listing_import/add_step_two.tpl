{breadcrumbs}
	<a href="{$GLOBALS.site_url}/show-import/">[[Job Auto Import]]</a>
	{if $id > 0}
		&#187; [[Edit Data Source]]
	{else}
		&#187; [[Add new Data Source - step two]]
	{/if}
{/breadcrumbs}

<h1><img src="{image}/icons/recycle32.png" border="0" alt="" class="titleicon"/>[[Data source parameters]]</h1>

<script type="text/javascript">

function in_array(what, where) {
	for(var i=0; i<where.length; i++) {
		if (what == where[i]) {
			return i;
		}
	}
	return -1;
}

var id = {$id};

{if $selected}
var selected = new Array();
{foreach from=$selected item=one}
	selected.push('{$one}');
{/foreach}

var a_selected = new Array();
{foreach from=$a_selected item=one}
	a_selected.push('{$one}');
{/foreach}


{/if}

$(function() {
	if (id > 0){
		$(".draggable").each(function(i){
			var drag = $(this);
			var isset = in_array(drag.attr('id'), selected);
			  if (isset >= 0){
				  var drop = $("#"+a_selected[isset] + ".droppable");
				  var input = "<input type='hidden' name='mapped[]' value='"+drop.attr('id')+':'+drag.attr('id')+"'>";
				  $("#defaultValue_"+drag.attr('id')).css("display", "none");
				  drop.html(input);
				  drop.append(drag);
			  }
		});
	}
	
	$("#manage_form").submit( function() { // check input data
		if ($.trim($("#parser_name").val()).length == 0) {
			alert('[[Please, select name for parser]]'); return false; }

		var external_id = $("#external_id");
		if (external_id.val() != '') {
			var iner = "<input type='hidden' name='mapped[]' value='"+external_id.val()+'_external_id:'+external_id.attr('id')+"'>";
			$(this).append(iner);
		}
	
		if ($('#selectUserTypeU').attr('checked') === true && $.trim($("#parser_user_username").val()).length == 0) {
			alert('[[Please, enter valid user name]]'); return false;
		}
		else if ($('#selectUserTypeG').attr('checked') === true && $.trim($("#parser_user_group").val()).length == 0) {
			alert('[[Please, select user group]]');return false;
		}
		if ($('#postUnderProduct').val() == '') {
			alert('[[Please select a product]]'); return false;
		}
		if ($.trim($("#parser_url").val()).length == 0) {
			alert('[[Please, enter url for import]]'); return false; }
		return true;
	});
	
	$(".draggable").draggable({
		revert: 'invalid',
		cursor: 'move'
	});

	$(".droppable2").droppable({
		activeClass: 'ui-state-highlight2',
		hoverClass: 'ui-state-drophover2',
		accept: '.draggable',
		drop: function(event, ui) {
		$(ui.draggable).css("top", $(this).position().top + 5);
			$(ui.draggable).css("left", $(this).position().left +5);
		}
	});
	
	$(".droppable").droppable({
		activeClass: 'ui-state-highlight',
		hoverClass: 'ui-state-drophover',
		accept: '.draggable',
		out: function(event, ui) {
			if ($(this).children("input").val() == $(this).attr('id')+':'+ui.draggable.attr('id')) {
				$(this).children("input").remove();
				$("#defaultValue_"+ui.draggable.attr('id')).css("display", "block");
			}
		},
		drop: function(event, ui) {
			if ($(this).children("input").size() > 0)
			{
				alert('[[Field can access only one item]]');
				//ui.draggable.draggable('option', 'revert', true);
				//ui.draggable.draggable('option', 'revert', 'invalid');
			} 
			else 
			{
				var iner = "<input type='hidden' name='mapped[]' value='"+$(this).attr('id')+':'+ui.draggable.attr('id')+"'>";
				$("#defaultValue_"+ui.draggable.attr('id')).css("display", "none");
				//$("#id_"+ui.draggable.html()).val('');
				$(this).append(iner);
			}
			$(ui.draggable).css("top", $(this).position().top + 5);
			$(ui.draggable).css("left", $(this).position().left +5);
		}
	});
});


</script>

{if $errors}
	{foreach from=$errors key=key item=error}
		{if $key === 'UPLOAD_ERR_INI_SIZE' || $error === 'UPLOAD_ERR_INI_SIZE'}
			<p class="error">[[File size shouldn't be larger than 5 MB.]]</p>
		{elseif $error === 'NOT_VALID_VALUE'}
			<p class="error">'[[{$key}]]' [[invalid value]]</p>
		{elseif $error === 'NOT_SUPPORTED_IMAGE_FORMAT'}
			<p class="error">'[[{$key}]]' - [[Image format is not supported]]</p>
		{elseif $error === 'UPLOAD_ERR_NO_FILE'}
			<p class="error">'[[{$key}]]' [[file not specified]]</p>
		{else}
			<p class="error">[[{$error}]]</p>
		{/if}
	{/foreach}
{/if}	

<form action="{$GLOBALS.site_url}/{if $editImport == 1}edit-import{else}add-import{/if}/{if $id > 0}?id={$id}{/if}" method="post" id="manage_form" enctype="multipart/form-data">
	<input type="hidden" name="xml" value="{$xml}">
	<input type="hidden" name="add_level" value="3">
	<input type="hidden" id="form_action" name="form_action" value="save_info"/>
		<table>
			<tr class="oddrow">
				<td><strong>[[Data Source Name]]</strong></td>
				<td><input type="text" name="parser_name" id="parser_name" value="{$form_name|escape:'html'}" style="width: 700px"></td>
			</tr>
			<tr class="evenrow">
				<td><strong>[[Data Source URL]]</strong></td>
				<td><input type="text" name="parser_url" id="parser_url" value="{$form_url|escape:'html'}" style="width: 700px"></td>
			</tr>
			<tr class="oddrow">
				<td><strong>[[Listings type]]</strong></td>
				<td>{$type_name}<input type="hidden" name="type_id" value="{$type_id}"></td>
			</tr>
			<tr class="evenrow">
				<td><strong>[[Listings will be created on behalf of]]:</strong></td>
				<td>
					<table id="clear">
						<tr>
							<td><input type='radio' name='selectUserType' id='selectUserTypeU' value='username' {if $add_new_user == 0}checked{/if}/>[[This user (enter user email)]]:</td>
							<td><input type="text" name="parser_user" id="parser_user_username" value="{if $add_new_user == 0}{$form_user|escape:'html'}{/if}" {if $add_new_user == 1}disabled="disabled"{/if} /></td>
						</tr>
						<tr>
							<td><input type='radio' name='selectUserType' id='selectUserTypeG' value='group' {if $add_new_user == 1}checked{/if} />[[User from XML data source (user will be imported automatically)]]</td>
							<td>
								<input type="hidden" name="parser_user" id="parser_user_group" {if $add_new_user == 0} disabled="disabled" {/if} value="41">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr class="oddrow">
				<td><strong>[[Post under product]]: </strong></td>
				<td>
					<div id="loading" style="display:none; position: absolute;">
						<img class="progBarImg" src="{$GLOBALS.user_site_url}/system/ext/jquery/progbar.gif" alt="[[Please wait ...]]" /> [[Please wait ...]]
					</div>
					<select id="postUnderProduct" name="postUnderProduct">
						<option value="">[[Select Product]]</option>
						{if !empty($products)}
							{foreach from=$products item=product}
								<option value="{$product.sid}" {if $selectedProduct == $product.sid}selected="selected"{/if}>[[{$product.name}]]</option>
							{/foreach}
						{/if}
					</select>
				</td>
			</tr>
			<tr class="evenrow">
				<td><strong>[[Description]]</strong></td>
				<td><textarea name="form_description" style="width: 700px;">{$form_description|escape:'html'}</textarea></td>
			</tr>

			<tr class="evenrow">
				<td><strong>[[Expired Listings from XML Feed will be]]:</strong></td>
				<td>
					<input type="radio" id="snapshot_import_type" name="import_type" value="snapshot" {if $import_type == 'snapshot'}checked="checked"{/if} />
					<label for="snapshot_import_type">[[Deleted]]</label>
					<br />
					<input type="radio" id="increment_import_type" name="import_type" value="increment" {if $import_type == 'increment'}checked="checked"{/if} />
					<label for="increment_import_type">[[Left till expiration]]</label>
				</td>
			</tr>
			
			
			<tr id="clearTable">
				<td colspan='2'>
					<div class="clr"><br/></div>
					<table class="manage_table">
						<thead>
							<tr>
								<th width='34%' align='center'><strong>[[Posting Fields]] </strong></th>
								<th width='34%' align='center'><strong>[[Default Value]] </strong></th>
								<th  align='center'><strong>[[XML Data Fields]]</strong></th>
							</tr>
						</thead>
						<tbody>
						<tr>
							<td valign="top" colspan='3'>
								<table width="100%">
									<tr>
										<td><div class="droppable2" ><div style='width: 150px; margin: 5px;'></div><strong>external_id</strong></div></td>
										<td style="width: 200px;">&nbsp;</td>
										<td align='right'>
											<div class="droppable">
												<div class="xml-data-fields">
													<select name='external_id' id='external_id' style="width: 190px;">
														<option value=''>[[Select field]]</option>
														{foreach from=$tree key=main_key item=one}
															<option value='{$one.key}' {if $external_id == $one.key }selected{/if}>{$main_key|replace:"_dog_":"@"|replace:"_":" - "}</option>
														{/foreach}
													</select>
												</div>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top" colspan='2'>
								<table width="100%">
									{foreach from=$fields item=fild}
										{if $fild.id != 'external_id'}
										<tr>
											<td class="td_height"><div class="droppable2"><div class="draggable" title="[[Drag and drop to the appropriate XML field]]" id="{$fild.id}">[[{$fild.caption}]]</div></div></td>
											{assign var="fieldId" value=$fild.id}
											<td class="td_height" style="min-width: 220px;"><div id='defaultValue_{$fieldId}'><span style='font-size:11px;'>[[{$fild.caption}]]:</span><br /><input type="text" name='default_value[{$fieldId}]' id='id_{$fieldId}' value="{$default_value.$fieldId|escape:'html'}"  /></div></td>
										</tr>
										{/if}
									{/foreach}
								</table>
							</td>

							<td valign="top">
								<table width="100%">
									{foreach from=$tree key=main_key item=one}
										<tr>
											<td class="td_height" align="right">&nbsp;[[{$main_key|replace:"_dog_":"@"|replace:"_":" - "}]]</td>
											<td class="td_height"><div class="droppable" id="{$one.key}"></td>
										</tr>
									{/foreach}
								</table>
							</td>
						</tr>
					</tbody>
					</table>
				</td>
			</tr>
			<tr id="clearTable">
				<td colspan="2"><div id="user_fields"></div></td>
			</tr>
			<tr id="clearTable">
				<td colspan=2 align="center">
					<div class="floatRight">
						<input type="submit" id="apply" value="[[Apply]]" class="grayButton"/>
						<input type="submit" value="[[Save]]" class="grayButton"/>
					</div>
				</td>
			</tr>
		</table>
</form>	
{capture name="selectProduct"}[[Select Product]]{/capture}

<script type="text/javascript">
$("#selectUserTypeU").click(function() {
	$("#parser_user_group").attr("disabled", "disabled");
	$("#parser_user_username").removeAttr("disabled");
	$("#user_fields").hide();
});
$("#selectUserTypeG").click(function() {
	$("#parser_user_username").attr("disabled", "disabled");
	$("#parser_user_username").val('');
	$("#parser_user_group").removeAttr("disabled").change();
	$("#user_fields").show();
});

if($("#selectUserTypeG").attr('checked') === true) {
	var url = '{$GLOBALS.site_url}/listing-import/user-fields/';
	$.post(url, { "user_group_sid": $("#parser_user_group").val(), 'id':{$id}, 'xml':'{$xmlToUser|base64_encode}'}, function(data){
		$("#user_fields").html(data);
	});
}

$('#apply').click(
	function(){
		$('#form_action').attr('value', 'apply_info');
	}
);

function getProducts()
{
	var parser_user = $(this).val();
	if ($(this).attr('id') != 'parser_user_group' || $(this).is(':disabled')) {
		parser_user = $("#parser_user_username").val();
	} else {
		var url = '{$GLOBALS.site_url}/listing-import/user-fields/';
		$.post(url, { "user_group_sid": $("#parser_user_group").val(), 'id':{$id}, 'xml':'{$xmlToUser|base64_encode}'}, function(data){
			$("#user_fields").html(data);
		});
	}
	var user_type = $("input[name='selectUserType']:checked").val();
	var url = '{$GLOBALS.site_url}/edit-import/';
	if (parser_user) {
		$.ajax({
			url: url,
			type: 'POST',
			data: { 'user_type': user_type, 'parser_user': parser_user},
			beforeSend: function() {
				$("#loading").show();
				$('#postUnderProduct').hide();
			},
			success: function(data){
				$("#loading").hide();
				var response = $.parseJSON(data);
				var defaultValue = '<option value="">{$smarty.capture.selectProduct|escape:"javascript"}</option>';
				if (response.error == '' && $.isArray(response.products)) {
					$('#postUnderProduct').empty();
					$("#postUnderProduct").append(defaultValue);
					$.each(response.products, function(index, value) {
						$("#postUnderProduct").append('<option value="'+value.sid+'">'+value.name+'</option>');
					});
					$('#postUnderProduct').show();
					if ("{$selectedProduct}" != '') {
						$("#postUnderProduct").val("{$selectedProduct}");
					}
				} else if (response.error != '') {
					alert(response.error);
					$('#postUnderProduct').empty();
					$("#postUnderProduct").append(defaultValue);
					$('#postUnderProduct').show();
				}
			}
		});
	}
}
$("document").ready(function(){
	$("#parser_user_group").change(getProducts).change();
	$("#parser_user_username").change(getProducts);
});
</script>