# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.


class ArticlesController < ApplicationController
  # Acts a controller for all articles
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user

  def index
    # Return list of all articles in order of date from newest to oldest
    @articles = Article.order(:date).reverse_order.page(params[:page]).per(10)

  end

  def my_interests
    # Return list of all articles with a matching tag to the users interests
<<<<<<< HEAD
    @articles = Article.tagged_with(current_user.interest_list, :any => true).to_a
    @articles = Kaminari.paginate_array(@articles).page(params[:page]).per(5)
=======
    @articles = get_interests current_user
>>>>>>> origin/master
    render 'index'
  end
  # GET /articles/1
  # GET /articles/1.json
  def show
  end
  def get_interests user
    return Article.tagged_with(user.interest_list, :any => true).to_a
  end



  # /articles/1/comment
  # as only exists on article put comment here, if able to edit articles new model



  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.


end
