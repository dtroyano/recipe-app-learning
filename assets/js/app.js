// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"


$().ready(() => {
    //Protect the user from clicking the delete button
    $('#deleteRecipe').click((e) => {

        if (confirm("Are you sure?")) {
        } else {
            e.stopPropagation();
        }
    });
    //add functionality to the add remove buttons
    const removeElement = ({ target }) => {
        let el = document.getElementById(target.dataset.id);
        let li = el.parentNode;
        li.parentNode.removeChild(li);
    }

    $(".remove-form-field").toArray().forEach((el) => {
        el.onclick = (e) => {
            removeElement(e);
        }
    });

    $(".add-form-field").toArray().forEach((el) => {
        el.onclick = ({ target: { dataset } }) => {
            let container = document.getElementById(dataset.container);
            let index = container.dataset.index;
            let newRow = dataset.prototype;
            container.insertAdjacentHTML("beforeend", newRow.replace(/__name__/g, index));
            container.dataset.index = parseInt(container.dataset.index) + 1;
            $(".remove-form-field").on("click", (e) => {
                removeElement(e);
            });
        }
    });
    //Reload the new image in the edit page
    $("#recipe_image").blur(() => {
        let newImage = $("#recipe_image").val();
        $("#recipeImage").attr('src', newImage);
    });
    //DropDown menu for username
    $("#userName h6").click(() => {
        $(".dropdown").toggleClass('show');
    });

});