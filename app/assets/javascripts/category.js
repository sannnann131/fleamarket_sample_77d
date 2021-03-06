$(document).on('turbolinks:load', function() {
  // カテゴリーセレクトボックスのオプションを作成
  function appendOption(category){
    let html = `<option value="${category.id}" data-category="${category.id}">${category.name}</option>`;
    return html;
  }
  // 子カテゴリーの表示作成
  function appendChildrenBox(insertHTML){
    let childSelectHtml = '';
    childSelectHtml = `<div class='items-select-wrapper' id='children_wrapper'>
                        <div class='items-select-wrapper__box'>
                          <select class="items-select-wrapper__box--select" id="children_category" required>
                           <option value="">選択して下さい</option>
                            ${insertHTML}
                          </select>
                        </div>
                      </div>`;
    $('.items__category').append(childSelectHtml);
  }
  // 孫カテゴリーの表示作成
  function appendGrandchildrenBox(insertHTML){
    let grandchildSelectHtml = `<div class='items-select-wrapper' id='grandchildren_wrapper'>
                                  <div class='items-select-wrapper__box'>
                                    <select class='items-select-wrapper__box--select' id='category_id' name="item[category_id]" required>
                                      <option value="">選択して下さい</option>
                                      ${insertHTML}
                                    </select>
                                  </div>
                                </div>`;
    $('.items__category').append(grandchildSelectHtml);
  }
  // 親カテゴリー選択後のイベント（子カテゴリーのセレクトタグを出す為のAjax通信）
  $('#parent_category').on('change', function(){
    let parentCategory = $('#parent_category').val(); //選択された親カテゴリーの値を取得
    console.log("親カテゴリーのIDは" + parentCategory);
    if (parentCategory != ""){ //親カテゴリーが初期値でないことを確認
      $.ajax({
        url: '/items/get_children_category',
        type: 'GET',
        data: { parent_name: parentCategory },
        dataType: 'json'
      })
      .done(function(children){
        $('#children_wrapper').remove(); //親が変更された時、子以下を削除する
        $('#grandchildren_wrapper').remove();
        let insertHTML = '';
        children.forEach(function(child){
          insertHTML += appendOption(child);
        });
        appendChildrenBox(insertHTML);
      })
      .fail(function(){
        alert('カテゴリー取得に失敗しました');
      })
    }else{
      $('#children_wrapper').remove(); //親カテゴリーが初期値になった時、子以下を削除するする
      $('#grandchildren_wrapper').remove();
    }
  });
  // 子カテゴリー選択後のイベント
  $('.items__category').on("change", '#children_wrapper', function(){
    let childId = $('#children_wrapper option:selected').val(); //選択された子カテゴリーのid取得
    console.log("子カテゴリーのIDは" + childId);
    if (childId != ""){//子カテゴリーが初期値で無い事を確認
      $.ajax({
        url: '/items/get_grandchildren_category',
        type: 'GET',
        data: { child_id: childId},
        dataType: 'json'
      })
      .done(function(grandchildren){
        if(grandchildren.length != 0){
          $('#grandchildren_wrapper').remove();//子が変更された時、孫以下を削除する
          let insertHTML = '';
          grandchildren.forEach(function(grandchild){
            insertHTML += appendOption(grandchild);
          });
          appendGrandchildrenBox(insertHTML);
        }
      })
      .fail(function(){
        alert('カテゴリーの取得に失敗しました');
      })
    }else{
      $('#grandchildren_wrapper').remove(); //子カテゴリーが初期値になった時、孫以下を削除する
    }
  });
});
