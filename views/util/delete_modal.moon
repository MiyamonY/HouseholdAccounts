class DeleteModal
  create_delete_modal: =>
    div class:{"ui", "small", "modal"}, id:"delete-confirm", ->
      div class:{"header"}, "確認"
      div class:{"content"}, ->
        text "本当に削除しますか?"
      div class:"actions", ->
        div class:{"ui", "positive", "basic", "button"}, "はい"
        div class:{"ui", "negative",  "basic", "button"}, "いいえ"

{:DeleteModal}
