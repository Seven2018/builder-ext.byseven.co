import Sortable from 'sortablejs';

const initSortable = () => {
  const list = document.querySelector('#items');
  Sortable.create(list, {
    ghostClass: 'ghost',
    onEnd: (event) => {
      const newPosition = event.newIndex + 1;
      const itemId = event.item.dataset.itemId;
      const formData = new FormData();
      formData.append('position', newPosition);

      Rails.ajax({
        type: "POST",
        url: `/content_module/${itemId}`,
        data: formData
      })
    }
  });
};

export { initSortable };
