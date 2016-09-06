{breadcrumbs}
	<a href="{$GLOBALS.site_url}/user-groups/">[[User Groups]]</a>
	&#187; <a href="{$GLOBALS.site_url}/edit-user-group/?sid={$group_info.sid}">[[{$group_info.name}]]</a>
	&#187; <a href="{$GLOBALS.site_url}/edit-user-profile/?user_group_sid={$group_info.sid}">[[Edit User Profile Fields]]</a>
	&#187; <a href='{$GLOBALS.site_url}/edit-user-profile-field/?sid={$field_info.sid}&user_group_sid={$group_info.sid}'>[[{$field_info.caption}]]</a>
	&#187; [[Edit Fields]]
{/breadcrumbs}
<h1>[[Edit Fields]]</h1>
<table>
	<thead>
		<tr>
			<th>[[ID]]</th>
			<th>[[Caption]]</th>
			<th>[[Required]]</th>
			<th>[[Hidden]]</th>
			<th colspan="5" class="actions">[[Actions]]</th>
		</tr>
	</thead>
	<tbody>
		{foreach from=$user_field_sids item=user_field_sid name=items_block}
			<tr class="{cycle values = 'evenrow,oddrow' advance=false}">
				<td>{display property='id' object_sid=$user_field_sid}</td>
				<td>{display property='caption' object_sid=$user_field_sid}</td>
				<td>{display property='is_required' object_sid=$user_field_sid}</td>
				<td>{display property='hidden' object_sid=$user_field_sid}</td>
				<td><a href="?sid={$user_field_sid}&amp;field_sid={$field_sid}&action=edit" title="[[Edit]]" class="editbutton">[[Edit]]</a></td>
				<td>{if $smarty.foreach.items_block.iteration < $smarty.foreach.items_block.total}<a href="?sid={$field_info.sid}&amp;field_sid={$user_field_sid}&amp;action=move_down"><img src="{image}b_down_arrow.gif" border="0" alt=""/></a>{/if}</td>
				<td>{if $smarty.foreach.items_block.iteration > 1}<a href="?sid={$field_info.sid}&amp;field_sid={$user_field_sid}&amp;action=move_up"><img src="{image}b_up_arrow.gif" border="0" alt=""/></a>{/if}</td>
			</tr>
		{/foreach}
	</tbody>
</table>